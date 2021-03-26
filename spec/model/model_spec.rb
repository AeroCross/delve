# frozen_string_literal: true

require_relative "../../model/model.rb"

RSpec.describe Model do
  let(:data) do
    [
      {
        "_id": "1",
        "email": "foo@bar.com",
        "name": "Foobar",
      },
      {
        "_id": "2",
        "email": "fizz@buzz.com",
        "name": "Fizzbuzz",
      },
    ]
  end

  describe "#find_by" do
    subject { Model.new(data).find_by(key, value) }

    context "when providing a matching key and value" do
      let(:key) { :email }
      let(:value) { "foo@bar.com" }

      it "returns an array with the results" do
        expect(subject.length).to eq(1)
        expect(subject[0]).to include({ name: "Foobar" })
      end
    end

    context "when providing a key that does not exist" do
      let(:key) { :superpowers }
      let(:value) { "Flying" }

      it "returns an empty array" do
        expect(subject).to be_empty
      end
    end

    context "when providing a key that exists but the value does not match" do
      let(:key) { :email }
      let(:value) { "danan-theman@vic.gov.au" }

      it "returns an empty array" do
        expect(subject).to be_empty
      end
    end
  end
end
