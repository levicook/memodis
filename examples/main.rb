require 'pathname'
require 'hitimes'

load Pathname.new(__FILE__).parent.parent + 'lib/memodis.rb'

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
