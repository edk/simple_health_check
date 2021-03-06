class SimpleHealthCheck::RedisCheck < SimpleHealthCheck::Base
  def initialize service_name: "redis", check_proc: nil, hard_fail: false
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.redis_check_proc
    @hard_fail = hard_fail
  end
end
