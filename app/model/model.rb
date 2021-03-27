# frozen_string_literal: true

class Model
  attr_reader :data, :result

  def initialize(data)
    @data = data
    @result = nil
  end

  def where(key, value)
    @result = data.select do |entry|
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

  def primary_key
    raise NotImplementedError
  end

  def unique_keys
    raise NotImplementedError
  end

  def foreign_keys
    raise NotImplementedError
  end
end
