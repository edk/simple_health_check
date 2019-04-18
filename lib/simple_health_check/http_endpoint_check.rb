# Useful for checking other service's health check endpoint
class SimpleHealthCheck::HttpEndpointCheck < SimpleHealthCheck::BaseNoProc
  def initialize(service_name: 'http_endpoint', check_proc: nil, url: nil)
    @service_name = service_name
    @proc = check_proc || SimpleHealthCheck::Configuration.http_endpoint_check_proc
    @type = 'service'
    @url = url
  end

  def call(response:)
    super do
      uri = URI(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if @url.include?('https')
      request = Net::HTTP::Get.new(uri)
      resp = http.request(request)
      (resp.read_body['status'] && :ok) || false
    end
  end
end
