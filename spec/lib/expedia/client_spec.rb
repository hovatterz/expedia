require "chronic"
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

  describe "#room_avail" do
    it "returns a hash containing the response from the API" do
      VCR.use_cassette("room_avail") do
        query = Hash.new
        query[:hotel_id] = 150873
        query[:arrival_date] = Chronic.parse("tomorrow").strftime("%m/%d/%Y")
        query[:departure_date] = Chronic.parse("next week").strftime("%m/%d/%Y")
        query[:room1] = "1,2"

        response = Expedia::Client.room_avail(query)
        response.has_key?(:hotel_room_response).must_equal true
        response[:hotel_id].must_equal query[:hotel_id].to_i
      end
    end
  end
end
