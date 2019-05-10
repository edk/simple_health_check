class SimpleHealthCheck::MysqlCheck < SimpleHealthCheck::BaseNoProc
  def initialize service_name: 'mysql', check_proc: nil
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.mysql_check_proc
    @type = 'internal'
    @version = nil
  end

  def call(response:)
    begin
      @version ||= version_check
    rescue
      @version = nil
    end
    super do
      ActiveRecord::Base.connection_pool.with_connection { |con| con.active? } rescue false
    end
  end

  def version_check
    ActiveRecord::Base.connection.select_rows('SELECT VERSION()')[0][0]
  end
end
