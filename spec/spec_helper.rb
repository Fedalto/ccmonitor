require 'rspec'
require 'rspec-expectations'
require 'vcr'
require 'rack/test'
require 'sinatra'

Dir["lib/**/*.rb"].each { |lib_file| load lib_file }

VCR.config do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.stub_with :webmock # or :fakeweb
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
  config.include Rack::Test::Methods
end
