require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = '--color --require spec_helper --format documentation'
end

task default: [:test]
