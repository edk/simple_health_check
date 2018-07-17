class SimpleHealthCheck::S3Check < SimpleHealthCheck::Base
  def call(response:)
    response.add name: 'svc_s3', status: 1
    response.status_code = :ok
    response
  end
end
