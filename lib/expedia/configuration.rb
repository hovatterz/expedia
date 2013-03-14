module Expedia
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    # @!attribute cid
    #   Your EAN-issued account ID
    # @!attribute api_key
    #   Your EAN-issued access key to the API
    # @!attribute shared_secret
    #   Your EAN-issued secret code
    # @!attribute minor_rev
    #   Sets the minor revision used for processing requests and
    #   returning responses
    attr_accessor :cid, :api_key, :shared_secret, :minor_rev

    def initialize
      self.cid = ""
      self.api_key = ""
      self.shared_secret = nil
      self.minor_rev = 4
    end
  end
end
