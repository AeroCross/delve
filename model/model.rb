# frozen_string_literal: true

class Model
  def find_by(key, value)
    data.select { |entry| entry[key] == value }
  end
end
