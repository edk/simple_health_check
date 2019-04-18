class SimpleHealthCheck::BasicStatus < SimpleHealthCheck::Base
  def call(response:)
    response.add name: 'status', status: :ok
    response.overall_status = :ok
    response
  end
end
