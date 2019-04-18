class SimpleHealthCheck::S3Check < SimpleHealthCheck::BaseProc
  def initialize service_name: 's3', check_proc: nil
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.s3_check_proc
    @type = 'service'
  end
end
