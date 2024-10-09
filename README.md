# Railmate

Utility for Rails app operation. It provides commands to check revision, open in browser, SSH to server, and download or view log files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "railmate", git: "https://github.com/socioart/railmate.git"
```

And then execute:

    $ bundle install
    $ bundle binstub railmate

## Usage

First. Run `railmate init` to create config file named `.railmate.yml`, and edit it.
Now, you can run all subcommands listed in output of `railmate` command.

    # curl to "${url}/revision"
    # See: https://github.com/labocho/rack-revision_route
    $ railmate revision

    # You can set environment (top level key in .railmate.yml) by `-e` option
    $ railmate -e production revision

    # Open "${url}"" in browser
    $ railmate browse

    # SSH to user@hostname
    $ railmate ssh

    # List and download files in "${directory}/log"
    $ railmate scplog

    # `tail` log files in "${directory}/log"
    $ railmate logs


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/railmate.

