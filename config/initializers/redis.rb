require "redis"

if ENV["REDIS_CRAWL"].present?
  Redis.crawl = Redis.new url: ENV["REDIS_CRAWL"]
  Redis.ping = Redis.new url: ENV["REDIS_PING"]
  Redis.pcap = Redis.new url: ENV["REDIS_PCAP"]
else
  raise "REDIS_URL is not present"
end

