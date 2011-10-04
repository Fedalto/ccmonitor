require 'open-uri'

require File.expand_path(File.join(File.dirname(__FILE__), 'model', 'build_info.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'build_info_parser.rb'))

class FeedReader
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def run
    build_infos = BuildInfoParser.parse open(@feed_url)

    build_infos.each do |info|
      old_info = BuildInfo.find_by_id(info.id)
      if old_info.nil?
        info.last_succeeded = Time.now
        info.time_since_green = 0
        info.recent = false
      else
        if info.state != old_info.state
          info.recent = true
        else
          info.recent = false
        end

        if info.succeeded?
          info.last_succeeded = Time.now
          info.time_since_green = 0
        else
          info.last_succeeded = old_info.last_succeeded
          info.time_since_green = Time.now.to_i - info.last_succeeded.to_i
        end
      end
      info.save!
    end

    SuperModel::Marshal.dump
  end
end
