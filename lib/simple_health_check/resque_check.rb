class SimpleHealthCheck::ResqueCheck < SimpleHealthCheck::BaseNoProc
  def initialize service_name: 'resque', check_proc: nil
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.resque_check_proc
    @type = 'internal'
  end

  def call(response:)
    super { (Resque.workers.empty? == false) }
  end
end
