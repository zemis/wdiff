require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "wdiff"
  gem.homepage = "http://github.com/zemis/wdiff"
  gem.license = "MIT"
  gem.summary = %Q{adds the wdiff method to String instance}
  gem.description = %Q{string word diff with other string; Wdiff::Helper.to_html transforms diff string in html snippet}
  gem.email = "jriga@zemis.co.uk"
  gem.authors = ["Jerome Riga"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

