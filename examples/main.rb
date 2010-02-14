require 'pathname'
load Pathname.new(__FILE__).parent.parent + 'lib/memodis.rb'

require 'rubygems'
require 'hitimes'

def fib( num )
  return num if num < 2
  fib(num - 1) + fib(num - 2)
end

print 'Before memoize: '
puts Hitimes::Interval.measure { fib(33) }


extend Memodis
memoize :fib

print ' After memoize: '
puts Hitimes::Interval.measure { fib(33) }


# Memodis::SimpleCluster.new(
#   :master => DistRedis.new(),
#   :slaves =>,
# )

# memoize :fib, Memodis::RedisCache.new(
#   :namespace => :fib,
#   :cluster => 
# )
