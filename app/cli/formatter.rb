# frozen_string_literal: true

require "paint"

module CLI
  module Formatter
    def format_header(text)
      Paint[text, :blue, :bold]
    end

    def format_field(text)
      Paint[text, :cyan]
    end

    def format_separator(text)
      Paint["\n\n#{text}\n", :yellow]
    end
  end
end
