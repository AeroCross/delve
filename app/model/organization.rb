# frozen_string_literal: true

require_relative "./model"

class Organization < Model
  def primary_key
    :"_id"
  end

  def unique_keys
    %i(_id url)
  end

  def foreign_keys
    []
  end
end
