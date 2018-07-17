class SimpleHealthCheck::RedisCheck < SimpleHealthCheck::Base
  def call(response:)
    response.add name: 'svc_redis', status: 1
    response.status_code = :ok
    response
  end
end
