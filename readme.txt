OAuth2 Elasticsearch Transport
==============================

Provides OAuth2 credentials negotiation on an Elasticsearch transport.

Usage:

Elasticsearch::Client.new(
  url: 'https://elasticsearch-server.no',
  transport_class: OAuth2ElasticsearchTransport,
  oauth2: {
    id: 'id',
    secret: 'secret',
    options: {
      site: 'https://credentials-server.no'
    }
  }
)

All options are passed to Elasticsearch::Client - i.e.: log, logger. The oauth2.id, oauth2.secret and oauth2.options options are converted into the respective parameters for OAuth2::Client - i.e.: 'id', 'secret', site: 'https://credentials-server.no', token_url: '/token'.

============================
Copyright (c) 2014 Globo.com
See license for details.
