Gem::Specification.new do |s|
  s.name = 'oauth2-elasticsearch-transport'
  s.version = '2.0.0'
  s.date = '2014-04-02'
  s.summary = "OAuth2 Elasticsearch Transport"
  s.description = "Provides OAuth2 credentials negotiation on an Elasticsearch transport"
  s.license = 'MIT'
  s.authors = ["Danilo Moret"]
  s.email = 'github@moret.pro.br'
  s.files = ["lib/oauth2-elasticsearch-transport.rb"]
  s.homepage = 'https://github.com/globocom/oauth2-elasticsearch-transport'
  s.add_dependency 'elasticsearch', '< 3.0'
  s.add_dependency 'oauth2', '~> 0.9'
  s.add_development_dependency "rspec"
  s.add_development_dependency "debugger"
  s.add_development_dependency "webmock"
end
