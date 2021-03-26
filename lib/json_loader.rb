# frozen_string_literal: true

require "json"

class JSONLoader
  attr_reader :data, :keys

  def self.call(source)
    new(source).data
  end

  def initialize(source)
    JSON.load_default_options = { symbolize_names: true }
    @data = JSON.load(source)
    @keys = []
  end

  def all_keys
    return keys unless keys.empty?

    data.each do |entry|
      next if keys == entry.keys
      @keys = keys + (entry.keys - keys)
    end

    return keys
  end
end
