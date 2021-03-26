# frozen_string_literal: true

require "thor"

module CLI
  module Command
    def data_path
      File.expand_path("./../../", File.dirname(__FILE__)) + "/data/"
    end
  end
end
