
module SimpleHealthCheck
  class SimpleHealthCheckController < ActionController::Base
    layout nil

    def show
      response = SimpleHealthCheck.run_simple_checks
      render json: response.body, status: :ok
    end

    def show_detailed
      response = SimpleHealthCheck.run_detailed_checks
      render json: response.body, status: :ok
    end
  end
end
