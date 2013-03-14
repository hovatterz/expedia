require_relative "../lib/expedia"

require "minitest/autorun"
require "webmock/minitest"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/expedia_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = {
    :record => :new_episodes,
    :match_requests_on => [:path]
  }
end

EAN_CID           = "REPLACEME"
EAN_API_KEY       = "REPLACEME"
EAN_SHARED_SECRET = "REPLACEME"

$client = Expedia::Client.new(EAN_CID, EAN_API_KEY, EAN_SHARED_SECRET)
