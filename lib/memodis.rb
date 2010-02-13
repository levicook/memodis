require 'pathname'


module Memodis

  # slurp cool vendor goodies into our namespace. would declare them 
  # as gem dependencies, but they don't seem to be published...

  VENDOR_PATH = Pathname.new(__FILE__).parent.parent + 'vendor'

  class_eval((VENDOR_PATH+'memoizable.rb').read) unless defined? Memodis::Memoizable
  class_eval((VENDOR_PATH+'weak_cache.rb').read) unless defined? Memodis::WeakCache

  include Memodis::Memoizable

end
