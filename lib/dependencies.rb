
require "pathname"
vendor_path = Pathname.new(__FILE__).parent.parent + "vendor"
Pathname.glob("#{vendor_path}/**/lib") do |lib|
  next if $LOAD_PATH.include?(lib)
  $LOAD_PATH.insert(0, lib.realpath.to_s) if lib.directory?
end

require "dist_redis"

