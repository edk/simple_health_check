# Pass in interval (minimum time in minutes between statsd calls pushing out status)
# pass in key_name and tags array to be used in statsd gauge
class SimpleHealthCheck::StatsDStatusCheck < SimpleHealthCheck::Base
  class << self
    @service_status_last_push = nil

    def try_push_status(interval, key_name, tags)
      last_push_time = @service_status_last_push
      current_time = Time.now
      if last_push_time.nil? || last_push_time < current_time - interval
        @service_status_last_push = current_time
        StatsD.gauge(key_name, 1, tags: tags)
        return true
      end
      false
    end
  end

  def initialize(interval: 5, key_name:, tags:)
    @interval = interval.minutes
    @key_name = key_name
    @tags = tags
  end

  def call(response:)
    result = self.class.try_push_status(@interval, @key_name, @tags)
    response.add name: 'pushed statsd', status: result
    response
  end
end