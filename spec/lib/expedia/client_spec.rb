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

  describe "#book_reservation" do
    it "returns a hash containing the response from the API" do
      query = {}
      query[:hotel_id] = 150873
      query[:arrival_date] = Chronic.parse("tomorrow").strftime("%m/%d/%Y")
      query[:departure_date] = Chronic.parse("next week").strftime("%m/%d/%Y")
      query[:room1] = "1,2"

      room = nil
      VCR.use_cassette("room_avail") do
        response = Expedia::Client.room_avail(query)
        room = response[:hotel_room_response].first
      end

      room.wont_equal nil

      VCR.use_cassette("book_reservation") do
        query = {}
        query[:hotel_id] = 150873
        query[:arrival_date] = Chronic.parse("tomorrow").strftime("%m/%d/%Y")
        query[:departure_date] = Chronic.parse("next week").strftime("%m/%d/%Y")
        query[:room1] = "1,2"
        query[:room1_first_name] = TEST_DATA[:first_name]
        query[:room1_last_name] = TEST_DATA[:last_name]
        query[:supplier_type] = room[:supplier_type]
        query[:rate_key] = room[:rate_infos][:rate_info][:room_group][:room][:rate_key]
        query[:room_type_code] = room[:room_type_code]
        query[:rate_code] = room[:rate_code]
        query[:number_of_adults] = 1 #optional?
        query[:number_of_children] = 2 #optional?
        query[:child_ages] = "3,5" #optional?
        if room[:supplier_type] == "E"
          # query[:bed_type_id] =  #optional?
          query[:chargeable_rate] = room[:rate_infos][:rate_info][:chargeable_rate_info][:total]
        else
          query[:chargeable_rate] = room[:rate_infos][:rate_info][:chargeable_rate_info][:max_nightly_rate]
        end
        #query[:smoking_preference] = #optional?
        query[:email] = TEST_DATA[:email]
        query[:first_name] = TEST_DATA[:first_name]
        query[:last_name] = TEST_DATA[:last_name]
        query[:home_phone] = TEST_DATA[:home_phone]
        query[:credit_card_type] = TEST_DATA[:credit_card_type]
        query[:credit_card_number] = TEST_DATA[:credit_card_number]
        query[:credit_card_identifier] = TEST_DATA[:credit_card_identifier]
        query[:credit_card_expiration_month] = TEST_DATA[:credit_card_expiration_month]
        query[:credit_card_expiration_year] = TEST_DATA[:credit_card_expiration_year]
        query[:address1] = "travelnow"
        query[:address2] = "Apt #17"
        query[:city] = "Murfreesboro"
        query[:state_province_code] = "TN"
        query[:country_code] = "US"
        query[:postal_code] = "37128"

        response = Expedia::Client.book_reservation(query)
        response.has_key?(:itinerary_id).must_equal true
        response[:confirmation_numbers].must_equal 1234
      end
    end
  end
end
