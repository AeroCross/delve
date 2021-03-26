# frozen_string_literal: true

require_relative "../../lib/json_loader.rb"

RSpec.describe JSONLoader do
  subject { JSONLoader.call(json) }

  let(:json) do
    [
      {
        a: "foo",
        b: "bar",
        c: "baz",
      },
      {
        c: "fizz",
        d: "buzz",
      },
    ].to_json
  end

  context "when valid JSON is passed to it" do
    it "loads a ruby data structure" do
      expect(subject.length).to eq(2)
      expect(subject[0]).to eq({ a: "foo", b: "bar", c: "baz" })
    end
  end

  describe "#all_keys" do
    subject { JSONLoader.new(json).all_keys }
    it "returns all the unique keys found at the top level of the data array" do
      expect(subject).to eq([:a, :b, :c, :d])
    end
  end
end
