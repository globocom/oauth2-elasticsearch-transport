require 'oauth2'
require 'elasticsearch'

class OAuth2ElasticsearchTransport < Elasticsearch::Transport::Transport::HTTP::Faraday
  TWO_MINUTES = 120

  def initialize arguments={}
    super arguments
    @client = OAuth2::Client.new arguments[:options][:oauth2][:id], arguments[:options][:oauth2][:secret], arguments[:options][:oauth2][:options]
  end

  def perform_request method, path, params, body
    unless @token && Time.now.to_i < ( @token.expires_at - TWO_MINUTES )
      @token = @client.client_credentials.get_token
      @headers = {
        'Content-Type' => 'application/json',
        'Authorization' => @token.options[:header_format] % @token.token
      }
    end

    Elasticsearch::Transport::Transport::Base.instance_method(:perform_request).bind(self).call(method, path, params, body) do |connection, url|
      connection.connection.run_request(
        method.downcase.to_sym,
        url,
        ( body ? __convert_to_json(body) : nil ),
        @headers
      )
    end
  end
end
