get "/wall" do
  session[:include_names] = params[:include_names].split(',') unless params[:include_names].nil?
  session[:exclude_names] = params[:exclude_names].split(',') unless params[:exclude_names].nil?
  session[:exclude_types] = params[:exclude_types].split(',') unless params[:exclude_types].nil?
  session[:versions] = params[:versions].split(',') unless params[:versions].nil?
  erb :wall
end

get "/all_projects" do
  xml_feed = open(settings.CONFIG[:FEED_URL])
  parser = ProjectsParser.new
  session[:exclude_types].each { |filter| parser.exclude_type(filter) } unless session[:exclude_types].nil?
  session[:versions].each { |filter| parser.include_version(filter) } unless session[:versions].nil?

  projects = parser.parse xml_feed

  name_exclude_filter = NameFilter.new
  session[:exclude_names].each { |name| name_exclude_filter.exclude(name) } unless session[:exclude_names].nil?
  session[:include_names].each { |name| name_exclude_filter.include(name) } unless session[:include_names].nil?

  filtered_projects = name_exclude_filter.filter projects

  JSON.generate({:projects => filtered_projects})
end
