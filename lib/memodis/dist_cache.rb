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

      @slaves = options.fetch(:slaves, []).map do |h|
        host, port = h.split(':')
        Redis.new({
          :db => options[:db],
          :host => host,
          :port => port,
          :timeout => options[:timeout],
        })
      end

      @encoder = case options[:encoder] 
                 when Proc; options[:encoder]
                 else; CODERS[options[:encoder]]
                 end

      @decoder = case options[:decoder] 
                 when Proc; options[:decoder]
                 else; CODERS[options[:decoder]]
                 end
    end

    def []= key, val
      @master.set(key, encode(val))
    end

    def [] key
      if val = get(key)
        decode(val)
      else
        nil # don't decode a miss
      end
    end

    private

    def indexed_slaves
      @indexed_slaves ||= begin
                            indexed_slaves = {}
                            #indexed_slaves.default = @master
                            @slaves.each do |slave|
                              slave_info = slave.info
                              master_host = slave_info[:master_host]
                              master_port = slave_info[:master_port]
                              key = "%s:%s" % [master_host, master_port]
                              indexed_slaves[key] = slave
                            end
                            indexed_slaves
                          end
    end

    def get key
      node = @master.node_for_key(String(key.first))
      indexed_slaves[node.server].get(key)
    end

    def decode(val)
      @decoder.call(val)
    end

    def encode(val)
      @encoder.call(val)
    end

  end

end
