require 'spec_helper'

describe CiscoSpark do
  it 'has a version number' do
    expect(CiscoSpark::VERSION).not_to be nil
  end

  context '#configuration' do
    after(:each) do
      CiscoSpark.clear_configuration!
    end

    context 'api_key' do
      let(:api_key) { SecureRandom.hex }

      it 'stores api an api key' do
        CiscoSpark.configure do |config|
          config.api_key = api_key
        end

        expect(CiscoSpark.api_key).to eq(api_key)
      end

      it 'raises an expection when the key is not set' do
        expect{CiscoSpark.api_key}.to raise_error(CiscoSpark::NoApiKeyError)
      end
    end

    context 'api_version' do
      let(:api_version) { 'any_version' }

      it 'stores api version' do
        CiscoSpark.configure do |config|
          config.api_version = api_version
        end

        expect(CiscoSpark.api_version).to eq(api_version)
      end

      it 'stores defaults to v1' do
        expect(CiscoSpark.api_version).to eq('v1')
      end
    end

    context 'api_domain' do
      let(:api_domain) { 'api.example.com' }

      it 'stores the domain' do
        CiscoSpark.configure do |config|
          config.api_domain = api_domain
        end

        expect(CiscoSpark.api_domain).to eq(api_domain)
      end

      it 'stores defaults to api.ciscospark.com' do
        expect(CiscoSpark.api_domain).to eq('api.ciscospark.com')
      end
    end
  end

  context 'api access' do
    let(:http_mock) do
      mock = double('HTTP mock')
      allow(mock).to receive(:use_ssl=).and_return(true)
      allow(mock).to receive(:request).and_return(exception)
      allow(Net::HTTP).to receive(:new).and_return(mock)
    end

    context 'invalid token' do
      let(:api_key) { 'invalid' }
      let(:exception) { Net::HTTPUnauthorized.new('body', 401, 'Unauthorized') }

      it 'raises an InvalidApiKeyError' do
        http_mock
        CiscoSpark.configure do |config|
          config.debug = true
        end

        expect do
          CiscoSpark.with_token(api_key) do
            CiscoSpark::Webhook.fetch_all
          end
        end.to raise_error(CiscoSpark::InvalidApiKeyError)
      end
    end

    context 'client error' do
      let(:api_key) { SecureRandom.hex }
      let(:exception) { Net::HTTPBadRequest.new('body', 400, 'BadRequest') }

      it 'raises an ApiClientError' do
        http_mock

        CiscoSpark.configure do |config|
          config.debug = true
        end

        expect do
          CiscoSpark.with_token(api_key) do
            CiscoSpark::Webhook.fetch_all
          end
        end.to raise_error(CiscoSpark::ApiClientError)
      end
    end

    context 'server error' do
      let(:api_key) { SecureRandom.hex }
      let(:exception) { Net::HTTPGatewayTimeOut.new('body', 504, 'GatewayTimeout') }

      it 'raises an ApiServerError' do
        http_mock

        CiscoSpark.configure do |config|
          config.debug = true
        end

        expect do
          CiscoSpark.with_token(api_key) do
            CiscoSpark::Webhook.fetch_all
          end
        end.to raise_error(CiscoSpark::ApiServerError)
      end
    end
  end
end
