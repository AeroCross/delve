# frozen_string_literal: true

require_relative "../ticket.rb"
require_relative "../organization.rb"

class User
  class AssociationBuilder
    attr_reader :result, :data

    def self.call(result, data)
      new(result, data).build
    end

    def initialize(result, data)
      @result = result
      @data = data
    end

    def build
      output = {}

      user = result[0]
      organization = Organization.new(data[:organizations])
      output[:organizations] = organization.where(:_id, user[:organization_id])
      output[:organizations].compact!

      ticket = Ticket.new(data[:tickets])
      output[:tickets] = ticket.where(:assignee_id, user[:_id])
      output[:tickets] << ticket.where(:submitter_id, user[:_id])
      output[:tickets].flatten!.compact!

      output
    end
  end
end
