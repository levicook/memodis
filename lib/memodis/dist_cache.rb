module Memodis

  class DistCache

    CODERS = {}
    CODERS.default   = lambda { |v| v }
    CODERS[:float]   = lambda { |v| Float(v) }
    CODERS[:integer] = lambda { |v| Integer(v) }
    CODERS.freeze

    def initialize(options)
      @master = DistRedis.new({
        :db => options[:db],
        :hosts => options[:master],
        :timeout => options[:timeout],
      })
      @slaves = options[:slaves].map do |h|
        host, port = h.split(':')
        Redis.new({
          :db => options[:db],
          :host => host,
          :port => port,
          :timeout => options[:timeout],
        })
      end
      @encoder = resolve_coder(options[:encoder])
      @decoder = resolve_coder(options[:decoder])
      @key_gen = options.fetch(:key_gen, lambda { |k| k })
      @expires = options[:expires]
    end

    def []= key, val
      key = canonicalize(key)
      @master.set(key, encode(val))
      @master.expire(key, @expires) unless @expires.nil?
    end

    def [] key
      key = canonicalize(key)
      if val = get(key)
        decode(val)
      else
        nil # don't decode a miss
      end
    end

    private

    def canonicalize(key)
      @key_gen.call(key)
    end

    def indexed_slaves
      @indexed_slaves ||= @slaves.inject(Hash.new) do |index, slave|
        slave_info  = slave.info
        master_host = slave_info[:master_host]
        master_port = slave_info[:master_port]
        index["#{master_host}:#{master_port}"] = slave
        index
      end
    end

    def get key
      m_node = @master.node_for_key(String(key.first))
      s_node = indexed_slaves[m_node.server] || m_node
      # TODO log warning if s_node == m_node
      s_node.get(key)
    end

    def decode(val)
      @decoder.call(val)
    end

    def encode(val)
      @encoder.call(val)
    end

    def resolve_coder(coder_spec)
      case coder_spec 
      when Proc
        coder_spec
      else
        CODERS[coder_spec]
      end
    end

  end

end
