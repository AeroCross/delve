# frozen_string_literal: true

require_relative "../../../app/cli/fields.rb"

RSpec.describe CLI::Fields do
  let(:source) { "users" }
  let(:options) { {} }

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
    ].to_json
  end

  let(:json_loader) { JSONLoader.new(json) }

  before do
    allow(Loader).to receive(:json_file).and_return(json_loader)
  end

  describe "#call" do
    subject { CLI::Fields.call(source, options) }

    context "when provided with a matching option" do
      it "returns a list of fields" do
        expect(subject).to eq(%i(id name email active roles))
      end
    end

    context "when provided with an option that is not supported" do
      let(:options) do
        { entities: true }
      end

      it "ignores it" do
        expect(subject).to eq(%i(id name email active roles))
      end
    end
  end
end
