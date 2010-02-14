require 'pathname'
load Pathname.new(__FILE__).parent.parent + 'lib/memodis.rb'

require 'rubygems'
require 'hitimes'

def fib(num)
  return num if num < 2
  fib(num - 1) + fib(num - 2)
end

print 'Before memoize: '
puts Hitimes::Interval.measure { fib(30) }


extend Memodis
memoize :fib

print ' After memoize: '
puts Hitimes::Interval.measure { fib(1000) }


Memodis::SimpleCluster.new(
  :master => '127.0.0.1:16379 127.0.0.1:16380'.split,
  :slaves => '127.0.0.1:16389 127.0.0.1:16390 
              127.0.0.1:16391 127.0.0.1:16392
              127.0.0.1:16393 127.0.0.1:16394'.split
)


# memoize :fib, Memodis::RedisCache.new(
#   :namespace => :fib,
#   :cluster => 
# )
