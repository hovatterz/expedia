require "active_support/core_ext/string/inflections"
require "httparty"
require "json"

module Expedia
  class ExpediaError < StandardError; end

  class Client
    # {http://developer.ean.com/docs/read/hotel_list Expedia Documentation}
    #
    # @param params [Hash] Query parameters to pass with the request
    def self.hotel_list(params={})
      make_request("list", :hotel_list_response, params)
    end

    # {http://developer.ean.com/docs/read/hotel_info Expedia Documentation}
    #
    # @param params [Hash] Query parameters to pass with the request
    def self.hotel_info(params={})
      make_request("info", :hotel_information_response, params)
    end

    # {http://developer.ean.com/docs/read/room_avail Expedia Documentation}
    #
    # @param params [hash] Query parameters to pass with the request
    def self.room_avail(params={})
      make_request("avail", :hotel_room_availability_response, params)
    end

    private

    # Makes a request to an endpoint and returns the response data
    #
    # @param endpoint [String] The API endpoint to hit
    # @param root [Symbol] The name of the root element in the response
    # @param params [Hash] Query parameters to pass with the request
    # @param method [Symbol] HTTP method to use for this request
    # @param secure [Bool] Specifies whether or not to use SSL
    def self.make_request(endpoint, root, params={}, method=:get, secure=false)
      params[:api_key] = Expedia.configuration.api_key
      params[:cid] = Expedia.configuration.cid
      params[:minor_rev] = Expedia.configuration.minor_rev
      params[:sig] = generate_signature if Expedia.configuration.shared_secret
      params = Helpers.requestify_hash(params)

      response = Request.make(endpoint, params, method, secure)
      parsed = Helpers.rubify_hash(JSON.parse(response.body))[root]

      return parsed unless parsed.has_key?(:ean_ws_error)
      raise ExpediaError.new(parsed[:ean_ws_error][:verbose_message])
    end

    # Generates a signature used to sign requests to the API
    def self.generate_signature
      Digest::MD5.hexdigest(Expedia.configuration.api_key +
                            Expedia.configuration.shared_secret +
                            Time.now.to_i.to_s)
    end
  end
end
