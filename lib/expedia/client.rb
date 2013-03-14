require "active_support/core_ext/string/inflections"
require "httparty"
require "json"

module Expedia
  class ExpediaError < StandardError; end

  class Client
    # @param cid Your EAN-issued account ID
    # @param api_key Your EAN-issued access key to the API
    # @param shared_secret your EAN-issued secret code
    # @param minor_rev Sets the minor revision used for processing requests
    #   and returning responses
    def initialize(cid, api_key, shared_secret, minor_rev=4)
      @cid = cid
      @api_key = api_key
      @shared_secret = shared_secret
    end

    # {http://developer.ean.com/docs/read/hotel_list Expedia Documentation}
    #
    # @param params [Hash] Query parameters to pass with the request
    def hotel_list(params={})
      make_request("list", :hotel_list_response, params)
    end

    # {http://developer.ean.com/docs/read/hotel_info Expedia Documentation}
    #
    # @param params [Hash] Query parameters to pass with the request
    def hotel_info(params={})
      make_request("info", :hotel_information_response, params)
    end

    private

    # Makes a request to an endpoint and returns the response data
    #
    # @param endpoint [String] The API endpoint to hit
    # @param root [Symbol] The name of the root element in the response
    # @param params [Hash] Query parameters to pass with the request
    # @param method [Symbol] HTTP method to use for this request
    # @param secure [Bool] Specifies whether or not to use SSL
    def make_request(endpoint, root, params={}, method=:get, secure=false)
      params[:api_key] = @api_key
      params[:cid] = @cid
      params[:sig] = generate_signature
      params = Helpers.requestify_hash(params)

      response = Request.make(endpoint, params, method, secure)
      parsed = Helpers.rubify_hash(JSON.parse(response.body))[root]

      return parsed unless parsed.has_key?(:ean_ws_error)
      raise ExpediaError.new(parsed[:ean_ws_error][:verbose_message])
    end


    # Generates a signature used to sign requests to the API
    def generate_signature
      Digest::MD5.hexdigest(@api_key + @shared_secret + Time.now.to_i.to_s)
    end
  end
end
