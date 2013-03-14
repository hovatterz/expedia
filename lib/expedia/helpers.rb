module Expedia
  module Helpers
    # Converts all keys in a hash to camelCase and strings
    def self.requestify_hash(hash)
      modify_hash_keys(hash) {|k| k.to_s.camelize(:lower) }
    end

    # Converts all keys in a hash to snake_case and symbols
    def self.rubify_hash(hash)
      modify_hash_keys(hash) {|k|
        k.to_s.underscore.gsub(/\@/, "").to_sym
      }
    end

    private

    # Modifies hash keys based on the given block
    #
    # @param hash [Hash] The hash that contains the keys to modify
    def self.modify_hash_keys(hash, &block)
      case hash
      when Array
        hash.map {|v| modify_hash_keys(v, &block) }
      when Hash
        Hash[hash.map {|k, v| [yield(k), modify_hash_keys(v, &block)] }]
      else
        hash
      end
    end
  end
end
