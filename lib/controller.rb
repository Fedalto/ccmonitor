require 'open-uri'

get "/wall" do
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])

  parser = ProjectsParser.new
  params[:exclude_types].split(',').each { |filter| parser.exclude_type(filter) } unless params[:exclude_types].nil?
  params[:versions].split(',').each { |filter| parser.include_version(filter) } unless params[:versions].nil?

  projects = parser.parse xml_feed

  name_exclude_filter = NameFilter.new
  params[:exclude_names].split(',').each { |name| name_exclude_filter.exclude(name) } unless params[:exclude_names].nil?
  params[:include_names].split(',').each { |name| name_exclude_filter.include(name) } unless params[:include_names].nil?

  filtered_projects = name_exclude_filter.filter projects
  JSON.generate({:projects => filtered_projects})
end
