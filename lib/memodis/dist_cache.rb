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
      @encoder = options.fetch(:encoder, CODERS[options[:encoder]])
      @decoder = options.fetch(:decoder, CODERS[options[:decoder]])
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

    def get key
      ## TODO read from slaves
      @master.get(key)
    end

    def decode(val)
      @decoder.call(val)
    end

    def encode(val)
      @encoder.call(val)
    end

  end

end
