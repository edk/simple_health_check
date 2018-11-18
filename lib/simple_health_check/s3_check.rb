class SimpleHealthCheck::S3Check < SimpleHealthCheck::Base
  def initialize service_name: "s3", check_proc: nil, hard_fail: false
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.s3_check_proc
    @hard_fail = hard_fail
  end
end
