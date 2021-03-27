# frozen_string_literal: true

require_relative "./model"

class User < Model
  def primary_key
    :"_id"
  end

  def unique_keys
    %w(_id)
  end

  def foreign_keys
    %w(organization_id)
  end
end
