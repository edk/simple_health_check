class SimpleHealthCheck::BaseProc < SimpleHealthCheck::Base
  def initialize service_name: nil, check_proc: nil
    super
  end

  # proc required call
  def call(response:)
    if @proc && @proc.respond_to?(:call)
      begin
        # @proc is a required user-supplied function to see if connection is working.
        start_time = Time.now
        connection = @proc.call
        @response_time = Time.now - start_time
        status = connection ? :ok : :crit
        response.overall_status = status
      rescue
        # catch exceptions since we don't want the health-check to bubble all the way to the top
        status = :crit
        error = $ERROR_INFO.to_s
        response.overall_status = :crit
      end
    else
      status = nil
      response.overall_status = :crit unless @no_config_needed
    end
    [status, error.to_s]
  end
end
