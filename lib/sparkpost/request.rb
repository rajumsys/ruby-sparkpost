require 'net/http'
require 'json'

require_relative 'version'
require_relative 'exceptions'

module SparkPost
  module Request

    def request(url, api_key, data)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = {
          'User-Agent' => 'ruby-sparkpost/' + VERSION,
          'Content-Type' => 'application/json',
          'Authorization' => api_key
      }
      req = Net::HTTP::Post.new(uri.path, initheader=headers)
      req.body = data.to_json

      process_response(http.request(req));
    end

    def process_response(response)
      response = JSON.parse(response.body)
      if response['errors']
        fail SparkPost::DeliveryException, response['errors']
      else
        response['results']
      end
    end    

    module_function :request, :process_response
  end
end
