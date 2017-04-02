require 'rake/extensiontask'
require 'rbconfig'
require 'rspec/core/rake_task'

# This is the `compile` task
Rake::ExtensionTask.new('smaz_ohm')

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = '--color --require spec_helper --format documentation'
end

desc 'Set up DevKit environment on Windows, call :compile task'
task :build do
  begin
    require 'devkit' if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  rescue LoadError
    warn('Warning: RubyInstaller Development Kit not found. I hope you have gcc and make and such, or else building Smaz will fail.')
  end

  Rake::Task[:compile].invoke
end


task default: [:build]
