require_relative "../../spec_helper"

describe Expedia::Request do
  describe ".make" do
    it "makes an HTTParty request with the given parameters" do
      uri = "http://p.#{Expedia::Request::BASE_URI}list"
      stub_http_request(:post, uri).with(:query => { :foo => "Test" })
      Expedia::Request.make("list", { :foo => "Test" }, :post, false, "p.")
      assert_requested(:post, uri, :query => { :foo => "Test" })
    end

    describe "when making a secure request" do
      it "prefixes the base uri with https://" do
        uri = "https://#{Expedia::Request::BASE_URI}list"
        stub_http_request(:get, uri).with(:query => { :foo => "Test" })
        Expedia::Request.make("list", { :foo => "Test" }, :get, true)
        assert_requested(:get, uri, :query => { :foo => "Test" })
      end
    end
  end
end
