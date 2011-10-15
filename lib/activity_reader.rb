require 'open-uri'

class ActivityReader
  require 'nokogiri'

  def initialize(url)
    @url = url
  end

  def log(msg)
    STDOUT.puts "#{Time.now}: #{msg}"
  end

  def run
    SuperModel::Marshal.load

    log "Reading feed: #{@url}"

    begin
      Nokogiri::XML(open(@url)).xpath('//Project').each do |project|
        version = project.get_attribute('name').split("-")[0]
        cdr = project.get_attribute('name').split("-")[1..-1].join('.')
        name = cdr.split('.')[0]
        type = cdr.split('.')[1..-1].join('.')

        build_info = BuildInfo.find_by_id(version + '-' + name + '-' + type)
        unless build_info.nil?
          build_info.activity = project.get_attribute('activity').downcase
          build_info.save!
        end
      end
    rescue => e
      log "Exception updating feed: #{e}"
    end

    log "Feed updated: #{@url}"
    SuperModel::Marshal.dump
  end
end
