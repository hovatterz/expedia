module Expedia
  class Request
    BASE_URI = "api.ean.com/ean-services/rs/hotel/v3/"

    # Makes a HTTParty request and returns the response
    #
    # @param endpoint [String] The API endpoint to hit
    # @param query [Hash] Query parameters to pass with the request
    # @param method [Symbol] HTTP method to use for this request
    # @param secure [Bool] Specifies whether or not to use SSL
    # @return [HTTParty::Response] the response for the request
    def self.make(endpoint, query={}, method=:get, secure=false)
      scheme = secure ? "https://" : "http://"

      HTTParty.send(method, scheme + BASE_URI + endpoint, :query => query)
    end
  end
end
