module AcceptanceExampleGroup
  extend ActiveSupport::Concern
  include Capybara
  Capybara.app = Sinatra::Application.new
  Capybara.default_driver = :selenium
  Capybara.default_wait_time = 5
  included { metadata[:type] = :acceptance }
end

RSpec.configure do |config|
  config.include AcceptanceExampleGroup, :example_group => { :file_path => /\bspec\/acceptance\// }
end
