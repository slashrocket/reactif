require "ohm"

Ohm.redis = Redic.new(ENV['REDIS_URL'])
