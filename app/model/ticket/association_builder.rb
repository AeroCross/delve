# frozen_string_literal: true

require_relative "../organization.rb"
require_relative "../user.rb"

class Ticket
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

      ticket = result[0]
      organization = Organization.new(data[:organizations])
      output[:organizations] = organization.where(:_id, ticket[:organization_id])
      output[:organizations].compact!

      user = User.new(data[:users])
      output[:users] = user.where(:_id, ticket[:assignee_id])
      output[:users] << user.where(:_id, ticket[:submitter_id])
      output[:users].flatten!.compact!

      output
    end
  end
end
