require_relative "../../spec_helper"

describe Expedia::Client do
  describe "#hotel_list" do
    it "returns a hash containing the response from the API" do
      VCR.use_cassette("hotel_list") do
        response = $client.hotel_list(:destination_string => "Athens, TN")
        response.has_key?(:hotel_list).must_equal true
      end
    end
  end
end
