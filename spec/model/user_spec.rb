# frozen_string_literal: true

require_relative "../../model/user.rb"

RSpec.describe User do
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
    subject { User.new(data).find_by(key, value) }
    context "when providing a correct key and value" do
      let(:key) { :email }
      let(:value) { "foo@bar.com" }

      it "returns an array with the results" do
        expect(subject.length).to eq(1)
        expect(subject[0]).to include({ name: "Foobar" })
      end
    end
  end
end
