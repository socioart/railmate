module Railmate
  Environment = Struct.new(:url, :ssh, :directory, keyword_init: true) do
    def self.load_file(path)
      YAML.load_file(path, aliases: true).each_with_object({}) do |(k, v), h|
        v.transform_keys!(&:to_sym)
        unknown_keys = v.keys - members

        unless unknown_keys.empty?
          raise "Unknown keys in `#{k}`: #{unknown_keys.join(", ")}"
        end

        h[k] = new(**v)
      end
    end

    def initialize(*)
      super
      validate!
      freeze
    end

    private
    def validate!
      raise InvalidConfigError, "`url` is required" if url.nil?
      raise InvalidConfigError, "`ssh` is required" if ssh.nil?
      raise InvalidConfigError, "`directory` is required" if directory.nil?

      begin
        URI.parse(ssh)
      rescue URI::InvalidURIError
        raise InvalidConfigError, "Invalid URL: #{url}"
      end

      begin
        URI.parse("ssh://#{ssh}")
      rescue URI::InvalidURIError
        raise InvalidConfigError, "Invalid ssh format: #{ssh}"
      end
    end
  end
end
