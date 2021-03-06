require 'open-uri'

require File.expand_path(File.join(File.dirname(__FILE__), 'model', 'build_info.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'model', 'feed_status.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'build_info_parser.rb'))

class FeedReader
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def log(msg)
    STDOUT.puts "#{Time.now}: #{msg}"
  end

  def run
    SuperModel::Marshal.load

    feed_status = FeedStatus.find_by_id('main_feed') || FeedStatus.new({'id' => 'main_feed'})

    log "Reading feed: #{@feed_url}"
    begin
      build_infos = BuildInfoParser.parse open(@feed_url)

      build_infos.each do |info|
        old_info = BuildInfo.find_by_id(info.id)
        if old_info.nil?
          info.last_succeeded = Time.now
          info.time_since_green = 0
          info.recent = false
        else
          info.activity = old_info.activity

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
        info.last_updated = Time.now
        info.save!
      end

      BuildInfo.all.each do |info|
        if not info.respond_to?('last_updated')
          info.destroy
        else
          if (Time.now - info.last_updated) >= (60*60)
            puts "Removing info: #{info.id}"
            info.destroy
          end
        end
      end

      feed_status.status = 'ok'
    rescue => e
      log "Exception thrown while reading feed: #{e}"
      feed_status.status = 'iiiiiiiiiiii'
    end
    log "Feed updated: #{@feed_url}"

    feed_status.save!
    SuperModel::Marshal.dump
  end
end
