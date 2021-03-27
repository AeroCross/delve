# frozen_string_literal: true

require "tty-table"
require_relative "../formatter.rb"

module CLI
  class Search
    class Renderer
      include Formatter

      attr_reader :data, :options

      def self.call(data, options)
        new(data, options).render
      end

      def initialize(data, options)
        @data = data
        @options = options
      end

      def render
        unless data
          puts "No results found"
          return
        end

        if options[:raw]
          puts data.to_json
          return
        end

        render_results

        if options[:associations]
          render_associations
        end
      end

      private

      def render_results
        data[:results].each do |entry|
          output = TTY::Table.new(header: [format_header("Fields"), format_header("Values")])

          entry.map do |key, value|
            output << [format_field(key.to_s), value.to_s]
          end

          puts output.render(:unicode, multiline: true, padding: [0, 2])
        end
      end

      def render_associations
        return false unless data[:associations]

        case data[:source]
        when "users"
          require_relative "./renderer/user_association_renderer.rb"
          UserAssociationRenderer.call(data)
        when "tickets"
          require_relative "./renderer/ticket_association_renderer.rb"
          TicketAssociationRenderer.call(data)
        when "organizations"
          require_relative "./renderer/organization_association_renderer.rb"
          OrganizationAssociationRenderer.call(data)
        end
      end
    end
  end
end
