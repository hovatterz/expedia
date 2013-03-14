require_relative "../../spec_helper"

describe Expedia::Client do
  describe "#hotel_list" do
    it "returns a hash containing the response from the API" do
      VCR.use_cassette("hotel_list") do
        response = Expedia::Client.hotel_list(:destination_string => "Athens, TN")
        response.has_key?(:hotel_list).must_equal true
      end
    end
  end

  describe "#hotel_info" do
    it "returns a hash containing the response from the API" do
      VCR.use_cassette("hotel_info") do
        hotel_id = "399395"
        response = Expedia::Client.hotel_info(:hotel_id => hotel_id)
        response[:hotel_id].must_equal hotel_id
      end
    end
  end
end
