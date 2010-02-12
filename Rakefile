require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "memodis"
    gem.summary = %Q{redis backed memoization helpers}
    gem.description = %Q{
semi-transparent memoization; backed by redis; redis-rb and redis-namespace

Background
-----------
1) http://blog.grayproductions.net/articles/caching_and_memoization
2) http://code.google.com/p/redis & http://github.com/ezmobius/redis-rb

Important Moving Parts
----------------------
1) http://code.google.com/p/redis/wiki/GetCommand
2) http://code.google.com/p/redis/wiki/SetCommand
3) http://code.google.com/p/redis/wiki/SetnxCommand
4) http://github.com/defunkt/redis-namespace
}
    gem.email = "levicook@gmail.com"
    gem.homepage = "http://github.com/levicook/memodis"
    gem.authors = ["levicook@gmail.com"]
    gem.add_development_dependency "riot", ">= 0"
    gem.add_development_dependency "reek", ">= 0"
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
