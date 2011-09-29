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
      else
        if info.succeeded?
          info.last_succeeded = Time.now
        else
          info.last_succeeded = old_info.last_succeeded
        end
      end
      info.save!
    end
  end
end
