# -*- coding: utf-8 -*-
require 'spec_helper'

describe OAuth2ElasticsearchTransport do
  let(:five_minutes) { 300 }

  let(:client) do
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
  end

  before do
    @post_token = stub_request(
      :post,
      'https://id:secret@credentials-server.no/oauth/token'
    ).with(
      body: 'grant_type=client_credentials'
    ).to_return(
      status: 200,
      headers: {
        'Content-Type' => 'application/json; charset=utf-8'
      },
      body: {
        'access_token' => 'some_token',
        'token_type' => 'bearer',
        'expires_in' => five_minutes
      }.to_json
    )

    @get_search = stub_request(
      :get,
      'https://elasticsearch-server.no/_search'
    ).with(
      headers: {
        'Authorization'=>'Bearer some_token',
        'Content-Type'=>'application/json'
    }).to_return(
      status: 200,
      body: {
        'test_result' => 'true'
      }.to_json
    )
  end

  context 'with first use' do
    before do
      client.search
    end

    it 'requests token once' do
      assert_requested @post_token
    end

    it 'searches once' do
      assert_requested @get_search
    end
  end

  context 'with second use' do
    before do
      client.search
      client.search
    end

    it 'requests token once' do
      assert_requested @post_token, times: 1
    end

    it 'searches twice' do
      assert_requested @get_search, times: 2
    end
  end

  context 'with two minutes before expiration' do
    let(:three_minutes) { 180 }

    before do
      client.search
      with_time(Time.now + three_minutes) do
        client.search
      end
    end

    it 'requests token again' do
      assert_requested @post_token, times: 2
    end
  end

  context 'when passing extra options' do
    let(:oauth2_options) do
      {
        site: 'https://credentials-server.no',
        hocus: 'pocus'
      }
    end

    let(:options) do
      {
        url: 'https://elasticsearch-server.no',
        transport_class: OAuth2ElasticsearchTransport,
        foo: 'bar',
        oauth2: {
          id: 'id',
          secret: 'secret',
          options: oauth2_options
        }
      }
    end

    let(:client) do
      Elasticsearch::Client.new options
    end

    it 'creates oauth2 client with oauth2 extra options' do
      expect(OAuth2::Client).to receive(:new).with('id', 'secret', oauth2_options)
      client
    end

    it 'creates elasticsearch client with base extra options' do
      expect(described_class.superclass).to receive(:new).with(
        hash_with(options: options)
      )
      client
    end
  end
end
