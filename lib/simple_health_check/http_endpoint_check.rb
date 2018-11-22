class SimpleHealthCheck::HttpEndpointCheck < SimpleHealthCheck::Base
  def initialize service_name: "http_endpoint", check_proc: nil, hard_fail: false
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.http_endpoint_check_proc
    @hard_fail = hard_fail
  end

  def call(response:)
    if @proc && @proc.respond_to?(:call)
      begin
        rv = @proc.call
        response.add name: @service_name, status: rv
        response.status_code = :ok
      rescue
        response.add name: "#{@service_name}_connection_error", status: $ERROR_INFO.to_s
      end
    else
      response.add name: @service_name, status: 'missing_configuration'
    end

    response
  end
end
