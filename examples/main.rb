require 'pathname'
load Pathname.new(__FILE__).parent.parent + 'lib/memodis.rb'

require 'rubygems'
require 'hitimes'

def fib(num)
  return num if num < 2
  fib(num - 1) + fib(num - 2)
end

puts 'Before memoize: '
puts Hitimes::Interval.measure { print fib(33); print ': ' }


extend Memodis

memoize :fib, Memodis::DistCache.new({
  :key_gen => lambda { |k| "fib(#{k})" },
  :decoder => :integer,
  :expires => (10 * 60),
  :master  => '127.0.0.1:16379 127.0.0.1:16380'.split,
  :slaves  => '127.0.0.1:16389 127.0.0.1:16390 
               127.0.0.1:16391 127.0.0.1:16392
               127.0.0.1:16393 127.0.0.1:16394'.split
})

puts "After memoize: "
puts Hitimes::Interval.measure { print fib(33); print ': ' }
puts Hitimes::Interval.measure { print fib(33); print ': ' }
puts Hitimes::Interval.measure { print fib(33); print ': ' }
