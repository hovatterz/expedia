module Expedia
  class Request
    BASE_URI = "api.ean.com/ean-services/rs/hotel/v3/"

    # Makes a HTTParty request and returns the response
    #
    # @param endpoint [String] The API endpoint to hit
    # @param query [Hash] Query parameters to pass with the request
    # @param method [Symbol] HTTP method to use for this request
    # @param secure [Bool] Specifies whether or not to use SSL
    # @param subdomain [String] Subdomain to prepend to the base uri
    # @return [HTTParty::Response] the response for the request
    def self.make(endpoint, query={}, method=:get, secure=false,
                  subdomain="")
      scheme = secure ? "https://" : "http://"

      options = { }
      if method == :post
        options[:body] = query
      else
        options[:query] = query
      end

      HTTParty.send(method, scheme + subdomain + BASE_URI + endpoint,
                    options)
    end
  end
end
