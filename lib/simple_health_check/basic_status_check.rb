class SimpleHealthCheck::BasicStatus < SimpleHealthCheck::Base
  def call(response:)
    response.add name: 'status', status: 1
    response.status_code = :ok
    response
  end
end
