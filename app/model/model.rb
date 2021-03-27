# frozen_string_literal: true

class Model
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def find_by(key, value)
    data.select do |entry|
      if entry[key].instance_of?(String)
        entry[key].downcase == value.downcase
      elsif entry[key].instance_of?(Array)
        downcased_entries = entry[key].map(&:downcase)
        downcased_entries.include?(value.downcase)
      else
        entry[key] == value
      end
    end
  end
end
