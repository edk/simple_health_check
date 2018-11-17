class SimpleHealthCheck::S3Check < SimpleHealthCheck::Base
  def call(response:)
    s3_check = SimpleHealthCheck::Configuration.s3_check_proc
    svc_name = "svc_s3"
    if s3_check && s3_check.respond_to?(:call)
      begin
        # s3_check is a required user-supplied function to see if the connection is working.
        rv = s3_check.call
        response.add name: svc_name, status: (rv || 'ok')
        response.status_code = :ok
      rescue
        # catch exceptions since we don't want the health-check to bubble all the way to the otp
        response.add name: 'svc_connection_error', status: $ERROR_INFO.message
      end
    else
      response.add name: svc_name, status: 'missing_configuration'
    end

    response
  end
end
