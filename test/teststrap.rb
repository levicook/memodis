require 'rubygems'
require 'riot'
require 'memodis'
Riot.dots


require 'memodis/local_redis_controller'
Dir['test/config/redis-server*.conf'].each do |config_file|
  Memodis::LocalRedisController.start(config_file)
end
