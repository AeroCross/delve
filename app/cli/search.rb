# frozen_string_literal: true

require "thor"
require_relative "./command"
require_relative "../../lib/loader.rb"

module CLI
  class Search
    include Command

    attr_reader :field, :value, :options, :data

    def self.call(field, value, options)
      new(field, value, options).search
    end

    def initialize(field, value, options)
      @field = field
      @value = value
      @options = options
    end

    def search
      source = if options[:users]
          require_relative "../../app/model/user.rb"
          { model: ::User, name: "users" }
        elsif options[:tickets]
          require_relative "../../app/model/ticket.rb"
          { model: ::Ticket, name: "tickets" }
        elsif options[:organizations]
          require_relative "../../app/model/organization.rb"
          { model: ::Organization, name: "organizations" }
        else
          nil
        end

      return false if source.nil?

      @data = Loader.json_file(file_to_load(source[:name]))
      result = source[:model].new(data.data).find_by(field.to_sym, value)

      if result.empty?
        puts "No results found"
      end

      puts result
      return result
    end

    private

    def file_to_load(filename)
      data_path + filename + ".json"
    end
  end
end
