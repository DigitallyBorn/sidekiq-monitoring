require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis =
    if ENV['REDIS_SENTINEL_SERVICE'].nil?
      { 
        url: (ENV['REDIS_URL'] || 'redis://redis'), 
        namespace: ENV['REDIS_NAMESPACE'] 
      }
    else
      {
        url: (ENV['REDIS_URL'] || 'redis://mymaster'),
        sentinels: [{ host: ENV['REDIS_SENTINEL_SERVICE'], port: '26379' }],
        namespace: ENV['REDIS_NAMESPACE']
      }
    end
end

require 'set'
require 'sidekiq/web'
# run Sidekiq::Web
run Rack::URLMap.new(ENV.fetch('SIDEKIQ_PATH', '/sidekiq') => Sidekiq::Web)
