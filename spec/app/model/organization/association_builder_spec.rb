# frozen_string_literal: true

require_relative "../../../../app/model/organization/association_builder.rb"

RSpec.describe Organization::AssociationBuilder do
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
      users: [
        {
          _id: 1,
          name: "Mario",
          organization_id: 2,
        },
        {
          _id: 2,
          name: "Paul",
          organization_id: 1,
        },
      ],
      tickets: [
        {
          _id: "foo-bar",
          title: "All is literally actually non-ironically on fire",
          status: "open",
          assignee_id: 2,
          submitter_id: 1,
          organization_id: 1,
        },
        {
          _id: "baz-qux",
          title: "There are cows with Bardiches everywhere",
          status: "open",
          assignee_id: 3,
          submitter_id: 1,
          organization_id: 2,
        },
      ],
    }
  end

  let(:result) do
    [
      {
        _id: 2,
        name: "Rush B",
        employees: 1,
      },
    ]
  end

  describe "#call" do
    subject { Organization::AssociationBuilder.call(result, data) }

    context "when provided the relevant data" do
      it "returns the associated data to the user" do
        expect(subject.keys).to include(:tickets, :users)
        expect(subject[:tickets][0]).to include(title: "There are cows with Bardiches everywhere")
        expect(subject[:users][0]).to include(name: "Mario")
      end
    end

    context "when the result set is empty" do
      let(:result) { }

      it "returns an empty set" do
        expect(subject).to be_empty
      end
    end
  end
end
