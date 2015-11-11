# BuildkiteFormatter

Takes FBSnapshotTestCase output and copies the artifacts to the first directory in BUILDKITE_ARTIFACT_PATHS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xcpretty-buildkite-formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcpretty-buildkite-formatter

## Usage

If you're using bundler:

    $ xcodebuild | xcpretty -f `bundle exec xcpretty-buildkite-formatter`

Or if you installed it yourself:

    $ xcodebuild | xcpretty -f `xcpretty-buildkite-formatter`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BlakeMesdag/xcpretty-buildkite-formatter.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
