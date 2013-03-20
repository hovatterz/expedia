require "active_support/core_ext/string/inflections"
require "httparty"
require "json"

module Expedia
  class ExpediaError < StandardError
    attr_accessor :handling, :category, :presentation_message,
      :verbose_message

    def initialize(handling, category, presentation_message,
                   verbose_message)
      super(verbose_message)

      self.handling = handling
      self.category = category
      self.presentation_message = presentation_message
      self.verbose_message = verbose_message
    end
  end

  class Client
    # {http://developer.ean.com/docs/read/hotel_list Expedia Documentation}
    #
    # @param query [Hash] Query parameters to pass with the request
    def self.hotel_list(query={})
      make_request("list", :hotel_list_response, query)
    end

    # {http://developer.ean.com/docs/read/hotel_info Expedia Documentation}
    #
    # @param query [Hash] Query parameters to pass with the request
    def self.hotel_info(query={})
      make_request("info", :hotel_information_response, query)
    end

    # {http://developer.ean.com/docs/read/room_avail Expedia Documentation}
    #
    # @param query [hash] Query parameters to pass with the request
    def self.room_avail(query={})
      make_request("avail", :hotel_room_availability_response, query)
    end

    # {http://developer.ean.com/docs/read/book_reservation Expedia Documentation}
    #
    # @param query [hash] Query parameters to pass with the request
    def self.book_reservation(query={})
      make_request("res", :hotel_room_reservation_response, query, :post,
                  true, "book.")
    end

    private

    # Makes a request to an endpoint and returns the response data
    #
    # @param endpoint [String] The API endpoint to hit
    # @param root [Symbol] The name of the root element in the response
    # @param query [Hash] Query parameters to pass with the request
    # @param method [Symbol] HTTP method to use for this request
    # @param secure [Bool] Specifies whether or not to use SSL
    # @param subdomain [String] Subdomain to prepend to the base uri
    def self.make_request(endpoint, root, query={}, method=:get,
                          secure=false, subdomain="")
      query[:api_key] = Expedia.configuration.api_key
      query[:cid] = Expedia.configuration.cid
      query[:minor_rev] = Expedia.configuration.minor_rev
      query[:sig] = generate_signature if Expedia.configuration.shared_secret

      query = Helpers.requestify_hash(query)

      response = Request.make(endpoint, query, method, secure, subdomain)
      parsed = Helpers.rubify_hash(JSON.parse(response.body))[root]

      return parsed unless parsed.has_key?(:ean_ws_error)
      error = parsed[:ean_ws_error]
      raise ExpediaError.new(error[:handling], error[:category],
                             error[:presentation_message],
                             error[:verbose_message])
    end

    # Generates a signature used to sign requests to the API
    def self.generate_signature
      Digest::MD5.hexdigest(Expedia.configuration.api_key +
                            Expedia.configuration.shared_secret +
                            Time.now.to_i.to_s)
    end
  end
end
