# Pass in scheduler_object (something with a job id + timestamps to measure executions)
# Pass in time_frame as Time object i.e. 30.minutes or 1.hour
# Or pass in your own proc
class SimpleHealthCheck::SchedulerCheck < SimpleHealthCheck::BaseNoProc
  def initialize service_name: 'scheduler', check_proc: nil, scheduler_object: nil, time_frame: nil
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.scheduler_check_proc
    @type = 'internal'
    @scheduler_object = scheduler_object
    @time_frame = time_frame
  end

  def call(response:)
    super do
      unless @time_frame.nil? | @scheduler_object.nil?
        (Time.now - @scheduler_object.send(:maximum, :updated_at)) <= @time_frame.to_i
      end
    end
  end
end
