require "active_support/core_ext/string/inflections"
require "httparty"
require "json"

module Expedia
  class ExpediaError < StandardError; end

  class Client
    include HTTParty
    base_uri "http://api.ean.com/ean-services/rs/hotel/v3/"

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
    # @param root_key [Symbol] The name of the root element in the response
    # @param params [Hash] Query parameters to pass with the request
    def make_request(endpoint, root_key, params={})
      params[:api_key] = @api_key
      params[:cid] = @cid
      params[:sig] = generate_signature

      response = self.class.get(endpoint, :query => camelize_hash(params))
      rubified = rubify_response(JSON.parse(response.body))[root_key]

      return rubified unless rubified.has_key?(:ean_ws_error)
      raise ExpediaError.new(rubified[:ean_ws_error][:verbose_message])
    end

    # camelCases a hash
    def camelize_hash(params)
      modify_hash_keys(params) {|k| k.to_s.camelize(:lower) }
    end

    # snake_cases the response
    def rubify_response(response)
      modify_hash_keys(response) {|k|
        k.to_s.underscore.gsub(/\@/, "").to_sym
      }
    end

    # Modifies hash keys based on the given block
    #
    # @param hash [Hash] The hash that contains the keys to modify
    def modify_hash_keys(hash, &block)
      case hash
      when Array
        hash.map {|v| modify_hash_keys(v, &block) }
      when Hash
        Hash[hash.map {|k, v| [yield(k), modify_hash_keys(v, &block)] }]
      else
        hash
      end
    end

    # Generates a signature used to sign requests to the API
    def generate_signature
      Digest::MD5.hexdigest(@api_key + @shared_secret + Time.now.to_i.to_s)
    end
  end
end
