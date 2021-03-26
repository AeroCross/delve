# frozen_string_literal: true

require "thor"
require_relative "./command"
require_relative "../../lib/loader.rb"

module CLI
  class Fields
    include Command

    attr_reader :options, :data

    def self.call(options)
      new(options).fields
    end

    def initialize(options)
      @options = options
    end

    def fields
      source = if options[:users]
          "users"
        elsif options[:tickets]
          "tickets"
        elsif options[:organizations]
          "organizations"
        else
          nil
        end

      return false if source.nil?

      @data = Loader.json_file(file_to_load(source))
      puts data.all_keys

      return true
    end

    private

    def file_to_load(filename)
      data_path + filename + ".json"
    end
  end
end
