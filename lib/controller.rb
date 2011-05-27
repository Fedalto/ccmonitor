require 'open-uri'

class App < Sinatra::Application

  get "/wall" do
    erb :wall
  end

  get "/all_projects" do
    xml_feed = open(settings.CONFIG[:FEED_URL])

    parser = ProjectsParser.new
    projects = parser.parse xml_feed

    name_filter = AttributeFilter.new 'name'
    params[:exclude_names].split(',').each { |name| name_filter.exclude(name) } unless params[:exclude_names].nil?
    params[:include_names].split(',').each { |name| name_filter.include(name) } unless params[:include_names].nil?

    type_filter = AttributeFilter.new 'type'
    params[:include_types].split(',').each { |type| type_filter.include(type) } unless params[:include_types].nil?
    params[:exclude_types].split(',').each { |type| type_filter.exclude(type) } unless params[:exclude_types].nil?

    version_filter = AttributeFilter.new 'version'
    params[:include_versions].split(',').each { |version| version_filter.include(version) } unless params[:include_versions].nil?
    params[:exclude_versions].split(',').each { |version| version_filter.exclude(version) } unless params[:exclude_versions].nil?

    filtered_projects = version_filter.filter(type_filter.filter(name_filter.filter projects))
    JSON.generate({:projects => filtered_projects})
  end

end
