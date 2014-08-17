# philtre-rails

It's the [Sequel](http://sequel.jeremyevans.net) equivalent for Ransack, Metasearch, Searchlogic. If
this doesn't make you fall in love, I don't know what will :-p

Parse the predicates on the end of field names, and round-trip the
search fields between incoming params, controller and views.

Start with the docs for [philtre](http://github.com/djellemah/philtre) and
then look here for rails integration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'philtre-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install philtre-rails

## Usage

In your filter form would look like this:

``` haml
.filter
  = form_for philtre.for_form, url: params.slice(:controller,:action), method: 'get' do |f|
    = f.hidden_field :order
    = f.text_field :title_like, placeholder: 'Fancy Title'
    = f.select :birth_year, (Date.today.year-90 .. Date.today.year).map( &:to_s), include_blank: 'Year'
    = f.submit 'Filter', name: nil, class: 'btn'
```

The ```for_form``` method is clunky. But ```ActiveModel``` seems to only use the result of ```to_model```
for naming and route generation, and then reverts to the object for the actual values.
I'm hoping they had a good reason to do it that way...

TODO ordering links and helper

## Specs

Nothing fancy. Just:

    $ rspec spec

## Contributing

1. Fork it ( https://github.com/djellemah/philtre-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
