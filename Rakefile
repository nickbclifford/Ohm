require 'rake/extensiontask'
require 'rbconfig'
require 'rspec/core/rake_task'

begin
  require 'devkit' if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
rescue LoadError
  warn('Warning: RubyInstaller Development Kit not found. I hope you have gcc and make and such, or else building Smaz will fail.')
end

# This is the `compile` task
Rake::ExtensionTask.new('smaz_ohm')

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = '--color --pattern spec/**/*.spec.rb --require spec_helper'
end

task default: [:compile]
