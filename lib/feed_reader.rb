require 'open-uri'

class FeedReader
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def run
    build_infos = BuildInfoParser.parse open(@feed_url)

    build_infos.each do |build_info|
      build_info.save!
    end
  end
end
