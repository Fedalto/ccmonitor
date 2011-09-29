require 'open-uri'

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
  end
end
