require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('Revver4R', '0.1.0') do |p|
  p.description    = "A simple Ruby interface for Revver's api."
  p.url            = "http://github.com/chalkers/revver4r"
  p.author         = "Andrew Chalkley"
  p.email          = "andrew@chalkely.org"
  p.ignore_pattern = ["tmp/*", "scripts/*"]
  p.development_dependencies = ["hpricot"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
