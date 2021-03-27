# frozen_string_literal: true

require "thor"
require_relative "./command"
require_relative "../../lib/loader.rb"
require_relative "../../app/model/user.rb"
require_relative "../../app/model/ticket.rb"
require_relative "../../app/model/organization.rb"

module CLI
  class Search
    include Command

    attr_reader :source, :field, :value, :options, :data

    def self.call(source, field, value, options)
      new(source, field, value, options).search
    end

    def initialize(source, field, value, options)
      @source = source
      @field = field
      @value = value
      @options = options
    end

    def search
      return false unless source_valid

      model = case source
        when "users"
          ::User
        when "tickets"
          ::Ticket
        when "organizations"
          ::Organization
        else
          nil
        end

      @data = Loader.json_file(file_to_load(source))
      model.new(data.data).find_by(field.to_sym, cast(value))
    end

    private

    def file_to_load(filename)
      data_path + filename + ".json"
    end
  end
end
