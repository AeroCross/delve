# frozen_string_literal: true

require_relative "../../spec_helper.rb"
require_relative "../../../app/cli/search.rb"

RSpec.describe CLI::Search do
  let(:field) { "name" }
  let(:value) { "Mario" }
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
        additional_notes: "",
      },
      {
        id: 2,
        name: "Paul",
        active: false,
        roles: ["guest"],
        additional_notes: "",
      },
    ]
  end

  let(:json_loader) { JSONLoader.new(json.to_json) }

  before do
    allow(Loader).to receive(:json_file).and_return(json_loader)
  end

  describe "#call" do
    subject { CLI::Search.call(source, field, value, options) }

    context "when provided with correct values" do
      it "returns results that have been found" do
        expect(subject).to eq(results: [json[0]], source: "users")
      end
    end

    context "when provided with an option that is not supported" do
      let(:options) do
        { entities: true }
      end

      it "ignores it" do
        expect(subject).to eq(results: [json[0]], source: "users")
      end
    end

    context "when the value matches with case insensitivity" do
      let(:field) { "name" }
      let(:value) { "mario" }

      it "reutnrs results that have been found" do
        expect(subject).to eq(results: [json[0]], source: "users")
      end
    end

    context "when the value is a number" do
      let(:field) { "id" }
      let(:value) { "2" }

      it "returns results that have been found" do
        expect(subject).to eq(results: [json[1]], source: "users")
      end
    end

    context "when the value is a boolean" do
      let(:field) { "active" }
      let(:value) { "true" }

      it "returns results that have been found" do
        expect(subject).to eq(results: [json[0]], source: "users")
      end
    end

    context "when the value is an array" do
      let(:field) { "roles" }
      let(:value) { "guest" }

      it "returns results that have been found" do
        expect(subject).to eq(results: [json[1]], source: "users")
      end
    end

    context "when the value is empty" do
      let(:field) { "additional_notes" }
      let(:value) { "" }

      it "returns results that have been found" do
        expect(subject).to eq(results: [json[0], json[1]], source: "users")
      end
    end
  end
end
