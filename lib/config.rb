require 'yaml'

class StatfulConfig < Hash
  attr_reader :env

  DEFAULT_LOCATION = %(config/statful.yml).freeze
  FORBIDDEN_FILE_CONFIGS = %w(:logger).map(&:freeze).freeze

  def self.load(config = {}, env = 'development')
    # Set config location
    ENV['STATFUL_CONFIG'] ||= File.expand_path(DEFAULT_LOCATION, Dir.pwd)
    @env = env

    # load configuration from statful.yml
    # delete FORBIDDEN_CONFIGS
    load_config_file
      .tap do |h|
        FORBIDDEN_FILE_CONFIGS.map do |k|
          h.delete(k)
        end
      end
      .merge(config)
  end

  private_class_method

  def self.load_config_file
    yaml = YAML.load_file(ENV['STATFUL_CONFIG'])[@env]

    # if configuration file is false
    yaml.class == Hash ? yaml : {}
  rescue Errno::ENOENT
    {}
  end
end

# Override Hash implementation to add a symbolize_keys method
#
class Hash
  # Recursively symbolize an Hash
  #
  # @return [Hash] the symbolized hash
  def symbolize_keys
    symbolize = lambda do |h|
      Hash === h ?
        Hash[
          h.map do |k, v|
            [k.respond_to?(:to_sym) ? k.to_sym : k, symbolize[v]]
          end
        ] : h
    end

    symbolize[self]
  end
end
