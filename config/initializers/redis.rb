 require "redis"

if ENV["REDIS_URL"].present?
   Redis.current = Redis.new url: ENV["REDIS_URL"]
else
  raise "REDIS_URL is not present"
end