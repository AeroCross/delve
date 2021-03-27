# frozen_string_literal: true

require_relative "./model"

class Ticket < Model
  def primary_key
    :"_id"
  end

  def unique_keys
    %i(_id url)
  end

  def foreign_keys
    %i(assignee_id submitter_id organization_id)
  end
end
