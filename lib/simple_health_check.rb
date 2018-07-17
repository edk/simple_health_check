require "simple_health_check/version"
%w[base basic_status_check version_check mysql_check redis_check s3_check].each do |file|
  require "simple_health_check/#{file}"
end
require "simple_health_check/configuration"
require "simple_health_check/engine"

module SimpleHealthCheck
  class Response
    def initialize
      @body = {}
      @status = :ok
    end

    def add name:, status:
      @body[name] = status
    end
    def status_code= val
      # if status is not currently ok, don't allow flipping to ok.
      if @status == :ok
        @status = val
      end
    end

    def body
      @body
    end

    def status
      @status || :ok
    end
  end

  class << self
    def run_checks
      response = SimpleHealthCheck::Response.new
      SimpleHealthCheck::Configuration.all_checks.each_with_object(response) do |check, obj|
        check.call(response: obj)
      end
      response
    end
  end
end
