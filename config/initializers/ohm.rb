require "ohm"
redisurl = ENV['REDIS_URL']
redisurl = "redis://127.0.0.1:6379" unless redisurl
Ohm.redis = Redic.new(redisurl)
