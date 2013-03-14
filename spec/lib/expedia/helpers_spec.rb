require_relative "../../spec_helper"

describe Expedia::Helpers do
  describe ".requestify_hash" do
    it "converts all hash keys (even nested) to camel case and strings" do
      hash = {
        :test_hash => { :testing_hash => [{ :foo_bar => "foo" }] },
        "test_key" => "test_value"
      }

      requestified_hash = {
        "testHash" => { "testingHash" => [{ "fooBar" => "foo" }] },
        "testKey" => "test_value"
      }

      Expedia::Helpers.requestify_hash(hash).must_equal requestified_hash
    end
  end

  describe ".rubify_hash" do
    it "converts all hash keys (even nested) to snake case and symbols" do
      hash = {
        "testHash" => { "testingHash" => [{ "fooBar" => "foo" }] },
        "testKey" => "test_value"
      }

      rubified_hash = {
        :test_hash => { :testing_hash => [{ :foo_bar => "foo" }] },
        :test_key => "test_value"
      }


      Expedia::Helpers.rubify_hash(hash).must_equal rubified_hash
    end
  end
end
