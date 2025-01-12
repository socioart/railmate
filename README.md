# Railmate

Utility for Rails app operation. It provides commands to check revision, open in browser, SSH to server, and download or view log files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "railmate", git: "https://github.com/socioart/railmate.git"
```

And then execute:

```bash
$ bundle install
$ bundle binstub railmate
```

## Usage

First. Run `railmate init` to create config file named `.railmate.yml`, and edit it.
Now, you can run all subcommands listed in output of `railmate` command.

```bash
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
```

## Configuration

Edit `.railmate.yml` in Rails root directory


```yaml
# Name of the environment
production:
    # The HTTP-accessible URL used by the `revision` and `browse` commands
    url: https://example.com
    # The SSH server used by the `ssh`, `scplog`, and `logs` commands
    # The user and port can be omitted.
    ssh: user@example.com:22
    # The Rails application directory on the server, used by the `scplog` and `logs` commands
    directory: /var/www/vhosts/example.com/app_name/current

# Another enviroment
staging:
    url: https://staging.example.com
    ssh: user@staging.example.com:22
    directory: /var/www/vhosts/staging.example.com/app_name/current
```


## zsh completion

The `zsh-completion` command prints the zsh completion script.
Save it to a directory included in your `$fpath`.

```
$ railmate zsh-completion > /path/to/fpath/_railmate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/railmate.

