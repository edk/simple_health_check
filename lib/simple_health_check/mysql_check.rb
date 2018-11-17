class SimpleHealthCheck::MysqlCheck < SimpleHealthCheck::Base
  def call(response:)
    mysql_check_proc = SimpleHealthCheck::Configuration.mysql_check_proc
    svc_name = "svc_msyql"
    if mysql_check_proc && mysql_check_proc.respond_to?(:call)
      begin
        # mysql_check_proc is a user-supplied function to see if mysql connection is working.
        # It can be as simple as `User.first`
        # If it doesn't throw an exception, we're good
        rv = mysql_check_proc.call
        response.add name: svc_name, status: (rv || 'ok')
        response.status_code = :ok
      rescue
        # catch exceptions since we don't want the health-check to bubble all the way to the otp
        response.add name: 'mysql_connection_error', status: $ERROR_INFO.message
      end
    else
      # try using standard connection methods to see if it is connected
      begin
        # note that ActiveRecord::Base.connected? may return false on initial app boot until a connection
        # in the connection pool connects.
        response.add name: svc_msyql, status: ActiveRecord::Base.connected?
        response.status_code = :ok
      rescue
        response.add name: svc_msyql, status: :error
        response.add name: "#{svc_msyql}_error", status: $ERROR_INFO.message
      end
    end

    response
  end
end
