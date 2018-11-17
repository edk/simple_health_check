
module SimpleHealthCheck
  class SimpleHealthCheckController < ActionController::Base
    layout nil

    def show
      response = SimpleHealthCheck.run_checks
      render json: response.body, status: response.status
    end
  end
end
