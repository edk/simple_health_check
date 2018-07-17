# Reads the contents of a file, expected to be a simple string,
# such as the output of `git rev-parse HEAD` or an svn version number
# Uses the module var `version_file` to store the filename
class SimpleHealthCheck::VersionCheck < SimpleHealthCheck::Base
  def call(response:)
    if @ver.nil?
      # memoize to avoid repeatedly reading from static file
      @ver = "unknown"
      if File.exist?(SimpleHealthCheck::Configuration.version_file)
        @ver = File.read(SimpleHealthCheck::Configuration.version_file).strip rescue "unknown"
      end
    end
    response.add name: 'version', status: @ver
    response.status_code = :ok # even with unkown versions, we'll return an ok status
    response
  end
end
