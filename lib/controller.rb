require 'open-uri'

class App < Sinatra::Application

  get "/" do
    redirect to("/wall")
  end

  get "/feed_status" do
    SuperModel::Marshal.load

    @feeds = FeedStatus.all
    erb :feed_status
  end

  get "/wall" do
    erb :wall
  end

  get "/all_projects" do
    SuperModel::Marshal.load

    infos = BuildInfo.all.map do |item|
      item.attributes
    end

    name_filter = create_filter :attribute => 'name', :include_exclude_param => 'names'
    type_filter = create_filter :attribute => 'build_type', :include_exclude_param => 'types'

    filtered_projects = type_filter.filter(name_filter.filter infos)

    if params[:alias_ecom] == 'true'
      filtered_projects = Alias.ecom(filtered_projects)
    end

    filtered_projects.sort! do |a,b|
      a['name'] <=> b['name']
    end

    JSON.generate({:projects => filtered_projects})
  end

  private
  def create_filter(details = {:attribute => nil, :include_exclude_param => nil})
    filter = AttributeFilter.new details[:attribute]
    includes = params["include_#{details[:include_exclude_param]}".to_sym]
    excludes = params["exclude_#{details[:include_exclude_param]}".to_sym]

    includes.split(',').each { |value| filter.include(value) } unless includes.nil?
    excludes.split(',').each { |value| filter.exclude(value) } unless excludes.nil?
    filter
  end

end
