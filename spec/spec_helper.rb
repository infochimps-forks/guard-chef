require 'rubygems'
require 'guard/chef'
require 'rspec'

require 'active_support/core_ext'

Dir["#{File.expand_path('..', __FILE__)}/support/**/*.rb"].each { |f| require f }

puts "Please do not update/create files while tests are running."

RSpec.configure do |config|
  config.color_enabled = true

  config.before(:each) do
    ENV["GUARD_ENV"] = 'test'
    @fixture_path = Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end

  config.after(:each) do
    ENV["GUARD_ENV"] = nil
  end

  def nostdout
    silence_stream(STDOUT){ yield }
  end
  def nostderr
    silence_stream(STDERR){ yield }
  end

end
