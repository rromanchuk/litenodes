class RedisClients

  def self.crawl
    @crawl ||= Redis.new url: ENV["REDIS_CRAWL"]
  end

  def self.ping
    @ping ||= Redis.new url: ENV["REDIS_PING"]
  end

  def self.pcap
    @pcap ||= Redis.new url: ENV["REDIS_PCAP"]
  end

  def self.pcap
    @export ||= Redis.new url: ENV["REDIS_EXPORT"]
  end

end