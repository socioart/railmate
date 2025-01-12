require "shellwords"
require "thor"
require "thor/zsh_completion"
require "uri"
require "yaml"

module Railmate
  class CLI < Thor
    include ZshCompletion::Command

    CONFIG_FILE = ".railmate.yml".freeze

    class_option :environment, type: :string, aliases: "-e", desc: "Set environment"

    desc "init", "Initialize config"
    method_option :force, type: :boolean, aliases: "-f", desc: "Overwrite existing config"
    def init
      if File.exist?(CONFIG_FILE) && !options[:force]
        warn "#{CONFIG_FILE} already exists. Use --force to overwrite."
        exit 1
      end

      File.write(CONFIG_FILE, <<~YAML)
        production:
          url: https://example.com
          ssh: staff@example.com
          directory: /var/www/vhosts/example.com/app_name/current
      YAML
      puts "#{CONFIG_FILE} created."
    end

    desc "revision", "Show revision"
    def revision
      url = URI.join(environment.url, "revision")
      command = "curl #{url.to_s.shellescape}"
      warn command
      exec command
    end

    desc "browse", "Open in browser"
    def browse
      url = environment.url
      command = "open #{url.to_s.shellescape}"
      warn command
      exec command
    end

    desc "ssh", "SSH to server"
    def ssh
      ssh = URI.parse("ssh://#{environment.ssh}")
      user = ssh.user || ENV.fetch("USER")
      hostname = ssh.hostname
      port = ssh.port&.to_i || 22
      command = "ssh #{user}@#{hostname} -p #{port}"
      warn command
      exec command
    end

    desc "scplog", "Download log files by scp"
    def scplog
      Scplog.run(environment)
    end

    desc "logs [FILE...]", "Print log file(s)"
    def logs(*paths)
      Logs.run(environment, paths)
    end

    private
    def config
      @config ||= Environment.load_file(CONFIG_FILE)
    rescue InvalidConfigError => e
      warn "ERROR: #{e.message} in config"
      exit 1
    end

    def environment
      @environment ||= select_environment || begin
        warn "Environment not found"
        exit 1
      end
    end

    def select_environment
      return config.fetch(options[:environment]) if options[:environment]
      return config.values.first if config.keys.size == 1

      loop do
        puts "Select environment:"
        config.keys.each.with_index(1) do |key, i|
          puts "#{i}: #{key}"
        end

        $stdout.print ">> "
        i = $stdin.gets.to_i - 1
        environment = config.keys[i]

        return config.fetch(environment) if environment
      end
    end
  end
end
