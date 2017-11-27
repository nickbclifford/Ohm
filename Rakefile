require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = '--color --require spec_helper --format documentation'
end

desc 'Check code coverage'
task :coverage do
  require_relative 'ohm'

  err = ''

  {
    'components' => '',
    'arithmetic' => 'Æ',
    'constants' => 'α',
    'extras' => '·',
    'time' => 'υ'
  }.each do |str, char|
    file = File.read("spec/#{str}_spec.rb")

    not_found = (
      Ohm::COMPONENTS[char] ||
      Ohm::COMPONENTS.reject {|_, h| h.keys.all? {|k| k.is_a?(String)}}
    ).keys.map {|c| char + c}.reject {|c| file.include?(c)}

    err << "No tests found for #{not_found.join(', ')} in #{str} spec\n" unless not_found.empty?
  end

  abort err unless err.empty?
end

task default: [:test]
