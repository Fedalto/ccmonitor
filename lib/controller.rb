require 'open-uri'

get "/wall" do
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])

  parser = ProjectsParser.new
  params[:versions].split(',').each { |filter| parser.include_version(filter) } unless params[:versions].nil?

  projects = parser.parse xml_feed

  name_filter = NameFilter.new
  params[:exclude_names].split(',').each { |name| name_filter.exclude(name) } unless params[:exclude_names].nil?
  params[:include_names].split(',').each { |name| name_filter.include(name) } unless params[:include_names].nil?

  type_filter = TypeFilter.new
  params[:include_types].split(',').each { |type| type_filter.include(type) } unless params[:include_types].nil?
  params[:exclude_types].split(',').each { |type| type_filter.exclude(type) } unless params[:exclude_types].nil?

  filtered_projects = type_filter.filter(name_filter.filter projects)
  JSON.generate({:projects => filtered_projects})
end
