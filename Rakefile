begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:test) do |t|
    t.rspec_opts = "--color --pattern spec/**/*.spec.rb --require spec_helper"
  end
rescue LoadError    
end
