# Reads the contents of a file, expected to be a simple string,
# such as the output of `git rev-parse HEAD` or an svn version number
# Uses the module var `version_file` to store the filename
class SimpleHealthCheck::VersionCheck < SimpleHealthCheck::Base
  def call(response:)
    # memoize to avoid repeatedly reading from static file
    @ver = nil
    if @ver.nil?
      if File.exist?(SimpleHealthCheck::Configuration.version_file)
        @ver = File.read(SimpleHealthCheck::Configuration.version_file).strip rescue 'unknown'
      end
      response.add name: 'version', status: @ver
    end
    response
  end
end
