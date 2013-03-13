require_relative "../lib/expedia"

require "minitest/autorun"
require "webmock/minitest"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/expedia_cassettes"
  c.hook_into :webmock
end
