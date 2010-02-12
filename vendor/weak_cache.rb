# 
# This cache uses weak references, which can be garbage collected.  When the 
# cache is checked, the value will be returned if it is still around, otherwise
# +nil+ is returned.
# 
# (Code by Mauricio Fernandez.)
# 
class WeakCache
  def initialize
    set_internal_hash
  end

  def method_missing( meth, *args, &block )
    __get_hash__.send(meth, *args, &block)
  end

  private

  def __get_hash__
    old_critical    = Thread.critical
    Thread.critical = true

    @valid or set_internal_hash
    return ObjectSpace._id2ref(@hash_id)
  ensure
    Thread.critical = old_critical
  end

  def set_internal_hash
    hash     = Hash.new
    @hash_id = hash.object_id
    @valid   = true

    ObjectSpace.define_finalizer(hash, lambda { @valid = false })
    hash = nil
  end
end
