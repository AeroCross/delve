# frozen_string_literal: true

require_relative "./model"

class User < Model
  attr_reader :data

  def initialize(data)
    @data = data
  end
end
