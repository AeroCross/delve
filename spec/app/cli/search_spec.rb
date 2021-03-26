# frozen_string_literal: true

require_relative "../../../app/cli/search.rb"

RSpec.describe CLI::Search do
  let(:field) { "name" }
  let(:value) { "Mario" }
  let(:options) do
    { users: true }
  end

  let(:json) do
    [
      {
        id: 1,
        name: "Mario",
        email: "mario@zendesk.com",
        active: true,
        roles: ["developer", "user"],
      },
      {
        id: 2,
        name: "Paul",
        active: false,
        roles: ["guest"],
      },
    ]
  end

  let(:json_loader) { JSONLoader.new(json.to_json) }

  before do
    allow(Loader).to receive(:json_file).and_return(json_loader)
  end

  describe "#call" do
    subject { CLI::Search.call(field, value, options) }

    context "when provided with correct values" do
      it "returns results that have been found" do
        expect(subject).to eq([json[0]])
      end
    end

    context "when provided with an option that is not supported" do
      let(:options) do
        { entities: true }
      end

      it "returns false" do
        expect(subject).to be false
      end
    end
  end
end
