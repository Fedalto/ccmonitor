require 'component_test_reader'

describe ComponentTestReader do
  before :each do 
    @html_failing_component_tests = "<html><pre class=\"compile-error-data\">PMD Identified 4 unit test violations in SolrPerfUtils's unit tests.Tests FAILED<br class=\"none\"/>One ore more component tests failed.  Current module is SolrSearchConfiguration<br class=\"none\"/></html>"
    @html_success_component_tests = ""

    @cruise_url = "some_url.com"
    @reader = ComponentTestReader.new(@cruise_url)
  end

  describe "#parse_page" do
    it "fails if the component tests are failing" do
      @reader.should_receive(:get_html).with(@cruise_url).and_return(@html_failing_component_tests)
      @reader.parse_page
      @reader.test_status.should == :failure 
    end

    it "succeds if the component tests are passing" do
      @reader.should_receive(:get_html).with(@cruise_url).and_return(@html_success_component_tests)
      @reader.parse_page
      @reader.test_status.should == :success 
    end
  end 

end

