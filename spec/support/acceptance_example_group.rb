module AcceptanceExampleGroup
  extend ActiveSupport::Concern
  include Capybara
  Capybara.run_server = false
  Capybara.app = Rack::Builder.parse_file(File.join(Sinatra::Application.root, 'config.ru')).first
  Capybara.run_server = false
  Capybara.default_driver = :selenium
  Capybara.default_wait_time = 5
  included { metadata[:type] = :acceptance }
end

RSpec.configure do |config|
  config.include AcceptanceExampleGroup, :example_group => { :file_path => /\bspec\/acceptance\// }
end
