# frozen_string_literal: true

require_relative "../ticket.rb"
require_relative "../user.rb"

class Organization
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
      return {} unless result

      output = {}

      organization = result[0]
      ticket = Ticket.new(data[:tickets])
      output[:tickets] = ticket.where(:organization_id, organization[:_id])
      output[:tickets].compact!

      user = User.new(data[:users])
      output[:users] = user.where(:organization_id, organization[:_id])
      output[:users].compact!

      output
    end
  end
end
