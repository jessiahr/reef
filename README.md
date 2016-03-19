# Reef

This is a start.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reef', git: 'https://github.com/jessiahr/reef.git'
```

And then install:

    $ bundle

Or install it yourself as:

    $ gem install reef

## Install

To use with Sprockets:

Include Reef CSS in `app/assets/stylesheets/application.scss`
```scss
 *= require reef
 ```

Include Reef JS in `app/assets/javascripts/application.js`
```js
//= require reef/vue
//= require reef/vue-resource
//= require reef
```

## Usage

In a view you can now use the `vue-with` helper to setup vue with data from your controller
```erb
<%= vue_with :data => {listData: ['cat', 'dog', 'fish']}, :debug => true %>
```

Render a component:
```html
<simple-list :list="listData"></simple-list>
```


<!-- 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/reef. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


-->
## License 

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
