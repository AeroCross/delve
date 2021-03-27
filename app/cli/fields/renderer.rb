# frozen_string_literal: true

require "tty-table"
require_relative "../formatter.rb"

module CLI
  class Fields
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

        output = TTY::Table.new(header: [format_header("Values")])

        data.each do |key|
          output << [format_field(key.to_s)]
        end

        puts output.render(:unicode, multiline: true, padding: [0, 2])
      end
    end
  end
end
