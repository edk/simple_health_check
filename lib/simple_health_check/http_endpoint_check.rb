class SimpleHealthCheck::HttpEndpointCheck < SimpleHealthCheck::Base
  def call(response:)
    redis_check_proc = SimpleHealthCheck::Configuration.redis_check_proc
    svc_name = "svc_redis"
    if redis_check_proc && redis_check_proc.respond_to?(:call)
      begin
        # redis_check_proc is a required user-supplied function to see if connection is working.
        rv = redis_check_proc.call
        response.add name: svc_name, status: (rv || 'ok')
        response.status_code = :ok
      rescue
        # catch exceptions since we don't want the health-check to bubble all the way to the otp
        response.add name: 'redis_connection_error', status: $ERROR_INFO.message
      end
    else
      response.add name: svc_name, status: 'missing_configuration'
    end

    response
  end
end
