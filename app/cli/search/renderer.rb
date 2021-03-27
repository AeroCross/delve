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
          puts data
          return
        end

        data.each do |entry|
          output = TTY::Table.new(header: [format_header("Fields"), format_header("Values")])

          entry.map do |key, value|
            output << [format_field(key.to_s), value.to_s]
          end

          puts output.render(:unicode, multiline: true, padding: [0, 2])
        end
      end
    end
  end
end
