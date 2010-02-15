require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "memodis"
    gem.summary = %Q{redis backed memoization helpers}
    gem.description = %Q{ semi-transparent memoization; backed by redis; }
    gem.email = "levicook@gmail.com"
    gem.homepage = "http://github.com/levicook/memodis"
    gem.authors = ["levicook@gmail.com"]
    gem.add_dependency "redis", ">= 0.1.2"
    gem.add_development_dependency "riot", ">= 0"
    gem.add_development_dependency "reek", ">= 0"
    gem.add_development_dependency "daemon_controller", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "memodis #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end



# redis test environment...

def write_redis_config(confile, port, slaveof=nil)
  pidfile = File.expand_path("test/pid/#{ File.basename(confile, '.*') }.pid")
  logfile = File.expand_path("test/log/#{ File.basename(confile, '.*') }.log")
  open(confile, 'w') do |f|
    f.puts "daemonize yes"
    f.puts "port #{port}"
    f.puts "pidfile #{pidfile}"
    f.puts "bind 127.0.0.1"
    f.puts "timeout 0"
    f.puts "dir ./test"
    f.puts "loglevel notice"
    f.puts "logfile #{logfile}"
    f.puts slaveof unless slaveof.nil?
    f.puts "databases 2"
    f.puts "maxmemory 6291456" 
    f.puts "glueoutputbuf yes"
    f.puts "shareobjects no"
    f.puts "shareobjectspoolsize 1024"
  end
end

directory 'test/config'
directory 'test/log'
directory 'test/pid'

(16379..16380).each do |port|
  config_file = "test/config/redis-server:#{port}.conf"
  file config_file => %w(test/config test/log test/pid) do
    write_redis_config(config_file, port)
  end
  namespace :test do
    task :config => config_file
  end
end

(16389..16394).each do |port|
  config_file = "test/config/redis-server:#{port}.conf"
  file config_file => %w(test/config test/log test/pid) do
    master_port = port.even? ? 16379 : 16380
    write_redis_config(config_file, port, "slaveof 127.0.0.1 #{master_port}")
  end
  namespace :test do
    task :config => config_file
  end
end

task :test => 'test:config'
