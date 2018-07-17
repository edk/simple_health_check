class SimpleHealthCheck::MysqlCheck < SimpleHealthCheck::Base
  def call(response:)
    status = 1
    response.add name: 'svc_msyql', status: status
    response.status_code = :ok
    response
  end
end
