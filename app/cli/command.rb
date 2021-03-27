# frozen_string_literal: true

require "thor"

module CLI
  module Command
    def data_path
      File.expand_path("./../../", File.dirname(__FILE__)) + "/data/"
    end

    def cast(value)
      return value if (value.instance_of?(Array))
      return value.to_i if (value.respond_to?(:to_i) && value.to_i.to_s == value)
      return value.to_sym if (value.class == Symbol || (value.respond_to?(:start_with?) && value.start_with?(":")))
      return true if value.downcase == "true"
      return false if value.downcase == "false"
      return value
    end

    def source_valid
      %w(users tickets organizations).include?(source)
    end
  end
end
