require "net/scp"
require "net/ssh"
require "shellwords"

module Railmate
  module Logs
    module_function
    def run(environment, paths)
      url = URI.parse("ssh://#{environment.fetch("ssh")}")
      user = url.user || ENV.fetch("USER")
      hostname = url.hostname
      port = url.port&.to_i || 22

      log_dir = File.join(environment.fetch("directory"), "log")
      logs = paths.empty? ? select_logs(hostname, user, port, log_dir) : paths

      command = ["ssh", "#{user}@#{hostname}", "-p", port, "tail", "-f", *logs.map {|l| "#{log_dir}/#{l}" }].shelljoin
      warn command
      exec command
    end

    def select_logs(hostname, user, port, log_dir)
      logs = nil
      Net::SSH.start(hostname, user, port: port) do |ssh|
        stdout = ""

        ssh.exec!("find #{log_dir}/ -type f") do |_ch, stream, data|
          stdout << data if stream == :stdout
        end

        logs = stdout.split("\n").map {|file| file[(log_dir.length + 1)..-1] }.sort

        logs = prompt_to_select(logs, "Which log you want to download: ")
      end
      logs
    end

    def prompt_to_select(list, prompt, &block)
      list.each_with_index do |item, i|
        label = block ? block.call(item) : item
        warn "#{i}) #{label}"
      end
      $stderr.write prompt

      answer = $stdin.gets.strip
      case answer
      when /\A(\d+)(-\d+)?(,(\d+)(-\d+)?)*\z/
        indices = answer.split(",").map {|range|
          f, l = range.split("-").map(&:to_i)
          l ||= f
          f..l
        }.flat_map(&:to_a)
        indices.map {|i| list[i] }.compact
      end
    end
  end
end
