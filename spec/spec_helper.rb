require_relative "../lib/expedia"

require "minitest/autorun"
require "webmock/minitest"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/expedia_cassettes"
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
  c.default_cassette_options = {
    :record => :new_episodes,
    :match_requests_on => [:path]
  }
end

Expedia.configure do |c|
  c.cid           = "REPLACEME"
  c.api_key       = "REPLACEME"
  c.shared_secret = "REPLACEME"
  c.minor_rev     = 4
end

TEST_DATA = {
  :first_name => "Test Booking",
  :last_name => "Test Booking",
  :email => "zackhovatter@gmail.com",
  :home_phone => "7045245698",
  :credit_card_type => "CA",
  :credit_card_number => "5401999999999999",
  :credit_card_identifier => "123",
  :credit_card_expiration_month => "03",
  :credit_card_expiration_year => "2020"
}
