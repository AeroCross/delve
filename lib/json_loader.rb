# frozen_string_literal: true

require "json"

class JSONLoader
  def self.call(file)
    JSON.load(file)
  end
end
