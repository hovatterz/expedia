# Expedia

Expedia API wrapper for Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'expedia'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install expedia

## Usage

TODO: Write usage instructions here

Example usage:
```ruby
require "expedia"

client = Expedia::Client.new("55505", "shazpjd62spew9wbacw943ps", "vbk3WMXU")

response = client.hotel_list(:destination_string => "Charlotte, NC")
response[:hotel_list][:hotel_summary].each do |hotel|
  puts hotel[:hotel_id]
end
```

## Tests

Edit `spec/spec_helper` and add your affiliate information (cid, API key,
and shared secret key) then run `rake test`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
