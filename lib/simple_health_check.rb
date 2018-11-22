require 'simple_health_check/base'
require 'simple_health_check/basic_status_check'

module SimpleHealthCheck
  %w[ generic_check http_endpoint_check json_file mysql_check redis_check s3_check version_check version].each do |file|
    classified_string = file.split('_').collect!{ |w| w.capitalize }.join
    autoload classified_string.to_sym, "simple_health_check/#{file}"
  end
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

    def status_code
      @status || :ok
    end

    def status_code= val
      @status = val
    end

    alias_method :status=, :status_code=
    alias_method :status, :status_code

    def body
      @body
    end

  end

  class << self
    def run_checks
      response = SimpleHealthCheck::Response.new
      overall_status = :ok
      SimpleHealthCheck::Configuration.all_checks.each_with_object(response) do |check, obj|
        begin
          rv = check.call(response: obj)
          if rv.status.to_s != 'ok' && check.should_hard_fail?
            overall_status = rv.status
          end
        rescue # catch the error and try to log, but keep going finish all checks
          response.add name: "#{check.service_name}_severe_error", status: $ERROR_INFO.to_s
          Rails.logger.error "simple_health_check gem ERROR: #{$ERROR_INFO}"
        end
      end
      response.status = overall_status
      response
    end
  end
end
