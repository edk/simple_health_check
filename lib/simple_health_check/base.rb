module SimpleHealthCheck
  class Base
    # derive a check class from this and add your checks.  the passed in response object
    # can set the key (name) and value (status) of the check to run.
    # All the combined checks are returned in a single hash.  Ensure you catch
    # any exceptions and set the reponse appropriately.
    # Make use of your derived check class by adding it to the list of check in your
    # app initializer:
    #
    # config/initializers/health_check.rb
    # ```
    # SimpleHealthCheck::Configuration.configure do |config|
    #   config.add_check SimpleHealthCheck::VersionCheck
    # end
    # ```
    # or, if you need to initialize the instance with data:
    # ```
    # SimpleHealthCheck::Configuration.configure do |config|
    #   config.add_check MyCheck.new(data)
    # end
    # ```
    def initialize service_name: nil, check_proc: nil, hard_fail: false
      @service_name = service_name
      @proc = check_proc
      @hard_fail = hard_fail
    end

    def should_hard_fail?
      @hard_fail
    end

    def call(response:)
      if @proc && @proc.respond_to?(:call)
        begin
          # @proc is a required user-supplied function to see if connection is working.
          rv = @proc.call
          response.add name: @service_name, status: rv
          response.status_code = rv
        rescue
          # catch exceptions since we don't want the health-check to bubble all the way to the top
          response.add name: "#{@service_name}_connection_error", status: $ERROR_INFO.message
          response.status_code = :internal_server_error
          response
        end
      else
        unless @no_config_needed
          response.add name: @service_name, status: 'missing_configuration'
          response.status_code = :internal_server_error
        end
      end

      response
    end

  end
end
