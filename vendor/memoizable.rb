#!/usr/local/bin/ruby -w

# memoizable.rb
#
#  Created by James Edward Gray II on 2006-01-21.
#  Copyright 2006 Gray Productions. All rights reserved.

# 
# Have your class or module <tt>extend Memoizable</tt> to gain access to the 
# #memoize method.
# 
module Memoizable
  # 
  # This method is used to replace a computationally expensive method with an
  # equivalent method that will answer repeat calls for indentical arguments 
  # from a _cache_.  To use, make sure the current class extends Memoizable, 
  # then call by passing the _name_ of the method you wish to cache results for.
  # 
  # The _cache_ object can be any object supporting both #[] and #[]=.  The keys
  # used for the _cache_ are an Array of the arguments the method was called 
  # with and the values are just the returned results of the original method 
  # call.  The default _cache_ is a simple Hash, providing in-memory storage.
  # 
  def memoize( name, cache = Hash.new )
    original = "__unmemoized_#{name}__"

    # 
    # <tt>self.class</tt> is used for the top level, to modify Object, otherwise
    # we just modify the Class or Module directly
    # 
    ([Class, Module].include?(self.class) ? self : self.class).class_eval do
      alias_method original, name
      private      original
      define_method(name) { |*args| cache[args] ||= send(original, *args) }
    end
  end
end
