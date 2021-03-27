# frozen_string_literal: true

require_relative "../../../../app/model/user/association_builder.rb"

RSpec.describe User::AssociationBuilder do
  let(:data) do
    {
      organizations: [
        {
          _id: 1,
          name: "The Young Gods",
          employees: 22,
        },
        {
          _id: 2,
          name: "Rush B",
          employees: 1,
        },
      ],
      tickets: [
        {
          _id: "foo-bar",
          title: "All is literally actually non-ironically on fire",
          status: "open",
          assignee_id: 2,
          submitter_id: 1,
        },
        {
          _id: "baz-qux",
          title: "There are cows with Bardiches everywhere",
          status: "open",
          assignee_id: 3,
          submitter_id: 1,
        },
      ],
    }
  end

  let(:result) do
    [
      {
        _id: 1,
        name: "Mario",
        organization_id: 2,
      },
    ]
  end

  describe "#call" do
    subject { User::AssociationBuilder.call(result, data) }

    it "returns the associated data to the user" do
      expect(subject.keys).to include(:organizations, :tickets)
      expect(subject[:organizations][0]).to include(name: "Rush B")
      expect(subject[:tickets][0]).to include(title: "All is literally actually non-ironically on fire")
    end
  end
end
