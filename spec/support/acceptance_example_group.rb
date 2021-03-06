module AcceptanceExampleGroup
  extend ActiveSupport::Concern
  include Capybara::DSL
  Capybara.app = Rack::Builder.parse_file(File.join(Sinatra::Application.root, 'config.ru')).first
  Capybara.default_driver = :selenium
  Capybara.default_wait_time = 5
  Capybara.server_boot_timeout = 50
  included { metadata[:type] = :acceptance }
end

RSpec.configure do |config|
  config.include AcceptanceExampleGroup, :example_group => { :file_path => /\bspec\/acceptance\// }
end
