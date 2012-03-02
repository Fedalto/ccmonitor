require 'net/http'

class ComponentTestReader
  attr_reader :test_status
  def initialize(url)
   @url = url
  end 
 
  def parse_page
    @test_status = get_html(@url).grep(/component tests failed/) ? :failure : :success
  end

  private
  def get_html(url)
    Net::HTTP.get(URI(url))
  end
end
