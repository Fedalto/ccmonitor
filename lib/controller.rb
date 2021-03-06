require 'open-uri'

class App < Sinatra::Application

  get "/" do
    redirect to("/wall")
  end

  get "/wall" do
    SuperModel::Marshal.load
    feed_status = FeedStatus.find_by_id('main_feed')
    if feed_status.nil? or not feed_status.ok?
      erb :feed_unavailable
    else
      response.headers["X-Frame-Options"] = "GOFORIT"
      erb :wall
    end
  end

  get "/all_projects" do
    SuperModel::Marshal.load

    infos = BuildInfo.all.map do |item|
      item.attributes
    end

    name_filter = create_filter :attribute => 'name', :include_exclude_param => 'names'
    type_filter = create_filter :attribute => 'build_type', :include_exclude_param => 'types'
    version_filter = create_filter :attribute => 'version', :include_exclude_param => 'versions'

    filtered_projects = version_filter.filter(type_filter.filter(name_filter.filter infos))

    if params[:alias_ecom] == 'true'
      filtered_projects = Alias.ecom(filtered_projects)
    end

    if params[:component_test] == 'true'
      ComponentTest.all.each do |component_test|
        new_project = infos.select { |e| e["name"] == component_test.name.to_s && e["build_type"] == "quick"}.first.dup
        new_project["state"] = component_test.status.to_s
        new_project["build_type"] = "component"
        filtered_projects.push(new_project)
      end
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
