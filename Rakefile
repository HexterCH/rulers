require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.name = "test"
  t.libs << "test"
  t.test_files = FileList['test/*test*.rb']
  t.verbose = true
end

task :default => :test
