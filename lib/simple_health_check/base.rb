module SimpleHealthCheck
  class Base
    attr_reader :service_name
    attr_reader :response_time
    attr_reader :type
    attr_reader :version
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
    def initialize service_name: nil, check_proc: nil
      @service_name = service_name
      @proc = check_proc
      @response_time = nil
      @version = nil
    end
  end
end
