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
      @data = {}
      @source = source
      @field = field
      @value = value
      @options = options
    end

    def search
      return false unless source_valid
      load_data

      search_model = model.new(data[source.to_sym])
      search_result = search_model.where(field.to_sym, cast(value))
      output = { source: source, results: search_result }

      if build_associations?(search_model)
        output[:associations] = build_associations(search_result)
      end

      return output
    end

    private

    def file_to_load(filename)
      data_path + filename + ".json"
    end

    def primary_key_search?(model)
      model.primary_key.to_s == field
    end

    def build_associations?(search_model)
      return options[:associations] && primary_key_search?(search_model)
    end

    def build_associations(result)
      case source
      when "users"
        require_relative "../../app/model/user/association_builder.rb"
        return User::AssociationBuilder.call(result, data)
      when "tickets"
        require_relative "../../app/model/ticket/association_builder.rb"
        return Ticket::AssociationBuilder.call(result, data)
      when "organizations"
        require_relative "../../app/model/organization/association_builder.rb"
        return Organization::AssociationBuilder.call(result, data)
      end
    end

    def load_data
      if options[:associations]
        %w(users tickets organizations).each do |entry|
          @data[entry.to_sym] = Loader.json_file(file_to_load(entry)).data
        end
      else
        @data[source.to_sym] = Loader.json_file(file_to_load(source)).data
      end
    end

    def model
      @model ||= case source
        when "users"
          ::User
        when "tickets"
          ::Ticket
        when "organizations"
          ::Organization
        end
    end
  end
end
