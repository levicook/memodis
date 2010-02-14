require 'daemon_controller'
require 'socket'

module Memodis
  class LocalRedisController
    
    def self.start(config_file)
      new(config_file).start
    end

    attr_reader :config, :controller

    def initialize(config_file)
      config = IO.readlines(config_file)
      config.reject!  { |l| l !~ /^(bind|port|pidfile|logfile)[ \t]?/ }
      config.collect! { |l| l.chomp.split(/[ \t]/) }
      config.flatten!
      config = Hash[*config]
      config['file'] = config_file
      @config = config
      @config.freeze

      @controller = DaemonController.new({
        :identifier => identifier,
        :start_command => start_command,
        :ping_command => ping_command,
        :pid_file => pid_file,
        :log_file => log_file
      })
    end

    def connect
      @controller.connect { TCPSocket.new(@config['bind'], @config['port']) }
    end
    alias :start :connect

    private

    def identifier
      "redis-server #{@config['file']}"
    end

    def start_command
      "redis-server #{@config['file']}"
    end

    def ping_command
      lambda { TCPSocket.new(@config['bind'], @config['port']) }
    end

    def pid_file
      @config['pidfile']
    end

    def log_file
      @config['logfile']
    end

  end
end
