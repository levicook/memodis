module Memodis

  class DistCache 

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
      @encoder = options.fetch(:encode, default_coder)
      @decoder = options.fetch(:decode, default_coder)
    end

    def [](key)
      decode(@master.get(key))
    end
      
    def []=(key, val)
      @master.set(key, encode(val))
    end

    private

    def default_coder
      lambda { |v| v }
    end

    def decode(val)
      @decoder.call(val)
    end

    def decode(val)
      @encoder.call(val)
    end

  end

end
