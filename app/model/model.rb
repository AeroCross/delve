# frozen_string_literal: true

class Model
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def find_by(key, value)
    data.select { |entry| entry[key] == value }
  end
end
