# frozen_string_literal: true

require "tty-table"
require_relative "../../formatter.rb"

module CLI
  class Search
    class Renderer
      class UserAssociationRenderer
        include Formatter

        attr_reader :data

        def self.call(data)
          new(data).render
        end

        def initialize(data)
          @data = data
        end

        def render
          puts format_separator("Organizations")
          data[:associations][:organizations].each do |organization|
            output = TTY::Table.new(header: [format_header("Organization Fields"), format_header("Values")])

            organization.map do |key, value|
              output << [format_field(key.to_s), value.to_s]
            end

            puts output.render(:unicode, multiline: true, padding: [0, 2])
          end

          puts format_separator("Tickets")
          data[:associations][:tickets].each do |ticket|
            output = TTY::Table.new(header: [format_header("Ticket Fields"), format_header("Values")])

            ticket.map do |key, value|
              output << [format_field(key.to_s), value.to_s]
            end

            puts output.render(:unicode, multiline: true, padding: [0, 2])
          end
        end
      end
    end
  end
end
