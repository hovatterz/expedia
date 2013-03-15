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

Example usage:
```ruby
require "expedia"

Expedia.configure do |c|
  c.cid = "CHANGEME"
  c.api_key = "CHANGEME"
  c.shared_secret = "CHANGEME"
end

response = Expedia::Client.hotel_list(:destination_string => "Charlotte, NC")
response[:hotel_list][:hotel_summary].each do |hotel|
  puts hotel[:hotel_id]
end
```

### Documentation

Just say `yard` and open `doc/index.html`.

### Tests

Edit `spec/spec_helper` and add your affiliate information (cid, API key,
and shared secret key) then run `rake test`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
