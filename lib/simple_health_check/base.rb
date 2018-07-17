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
    def call(response:)
      raise "Derive your own check from this class and add it to the checks"
      response.add name: 'name_of_check', status: Time.now
      reponse.status_code = :ok
      response
    end
  end
end
