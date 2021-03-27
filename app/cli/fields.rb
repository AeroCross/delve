# frozen_string_literal: true

require "thor"
require_relative "./command"
require_relative "../../lib/loader.rb"

module CLI
  class Fields
    include Command

    attr_reader :source, :options, :data

    def self.call(source, options)
      new(source, options).fields
    end

    def initialize(source, options)
      @source = source
      @options = options
    end

    def fields
      return false unless source_valid

      @data = Loader.json_file(file_to_load(source))
      data.all_keys
    end

    private

    def file_to_load(filename)
      data_path + filename + ".json"
    end
  end
end
