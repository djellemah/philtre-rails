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

### Filter form

Your controller would have something like this (you could also use the more
common ```@filter``` and ```@results``` as well if you like):

``` ruby
helper_method def filter
  @filter ||= Philtre.new philtre_params
end

helper_method def results
  # where Result is a Sequel::Model subclass, or actually any kind of dataset.
  @results ||= filter.apply Result
end
```

Note that by default your parameters will be in ```params[:philtre]```, for
which ```philtre_params``` is a convenience accessor.

And your filter form would look something like this:

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
I'm hoping I'm wrong, or they had a good reason to do it that way...

Don't forget the ```:order``` field. It will be important to hold the ordering state once you hook up ordering links.

Speaking of which...

### Basic Ordering links

``` haml
%table.results
  %thead
    %tr
      %th.party= order_by filter, :party
      %th.station= order_by filter, :station, label: 'Voting Station'
      %th.ra.votes= order_by filter, :votes, order_link_class: MyOrderLink

  -# not really ordering, but someone might find this useful
  %tbody
    - results.each do |result|
      %tr
        %td.party= result.party
        %td.station= result.station
        %td.ra.votes= result.votes
```

### Custom Ordering links

1) You can specify the ```order_link_class``` parameter to ```order_by```.

The ```OrderLink``` class defines:

* the icons (ie little chunks of html) that are displayed next to the order links

* the CSS class for the <a...> tag

* the ordering name which shows up in the filter parameters.

For example:

```ruby
class MyOrderLink < PhiltreRails::OrderLink
  def icon
    if active
      expr.descending ? '^' : 'v'
    else
      # optionally have a no-order icon
      '-'
    end
  end
end
```

2) If you don't want to specify ```:order_link_class``` repeatedly, you can also
replace the ```default_order_link_class``` method in a helper.

## Specs

Nothing fancy. Just:

    $ rspec spec

## Contributing

1. Fork it ( https://github.com/djellemah/philtre-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
