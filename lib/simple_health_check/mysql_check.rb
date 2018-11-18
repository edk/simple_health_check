class SimpleHealthCheck::MysqlCheck < SimpleHealthCheck::Base
  def initialize service_name: "msyql", check_proc: nil, hard_fail: false
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.mysql_check_proc
    @hard_fail = hard_fail
  end

  def call(response:)
    if @proc && @proc.respond_to?(:call)
      begin
        # @proc is a user-supplied function to see if mysql connection is working.
        # It can be as simple as `User.first`
        # If it doesn't throw an exception, we're good
        rv = @proc.call
        response.add name: @service_name, status: rv
        response.status_code = rv
      rescue
        # catch exceptions since we don't want the health-check to bubble all the way to the otp
        response.add name: "#{@service_name}_connection_error", status: $ERROR_INFO.message
        response.status_code = :internal_server_error
      end
    else
      # try using standard connection methods to see if it is connected
      begin
        # note that ActiveRecord::Base.connected? may return false on initial app boot until a connection
        # in the connection pool connects.
        response.add name: @service_name, status: ActiveRecord::Base.connected?
        response.status_code = :ok
      rescue
        response.add name: @service_name, status: :internal_server_error
        response.add name: "#{@service_name}_error", status: $ERROR_INFO.message
        response.status_code = :internal_server_error
      end
    end

    response
  end
end
