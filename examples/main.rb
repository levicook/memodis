require 'pathname'
load Pathname.new(__FILE__).parent.parent + 'lib/memodis.rb'

require 'rubygems'
require 'hitimes'

def fib(num)
  return num if num < 2
  fib(num - 1) + fib(num - 2)
end

puts 'Before memoize: '
puts Hitimes::Interval.measure { print fib(30); print ': ' }


extend Memodis

# TODO add namespace!!
cache = Memodis::DistCache.new({
  :key_gen => lambda { |k| "Kernel#fib(#{k})" },
  :decoder => :integer,
  :master  => '127.0.0.1:16379 127.0.0.1:16380'.split,
  :slaves  => '127.0.0.1:16389 127.0.0.1:16390 
               127.0.0.1:16391 127.0.0.1:16392
               127.0.0.1:16393 127.0.0.1:16394'.split
})

memoize :fib, cache 

puts "\nAfter memoize: "
puts Hitimes::Interval.measure { print fib(30); print ': ' }
puts Hitimes::Interval.measure { print fib(30); print ': ' }
puts Hitimes::Interval.measure { print fib(30); print ': ' }
