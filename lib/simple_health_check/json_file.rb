class SimpleHealthCheck::JsonFile < SimpleHealthCheck::Base
  def call(response:)
    json_file = SimpleHealthCheck::Configuration.json_file || 'info.json'
    if @json_info.nil? && File.exist?(json_file)
      @json_info = JSON.parse(File.read(json_file)) rescue nil
    end

    if @json_info.is_a?(Hash)
      @json_info.each do |k, v|
        response.add name: k, status: v
      end
      response.overall_status = :ok
    end

    response
  end
end
