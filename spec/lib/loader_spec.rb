# frozen_string_literal: true

require "byebug"
require_relative "../../lib/loader.rb"

TMP_DIR = "../../tmp"

before do
  @initial_location = Dir.pwd
  FileUtils.mkdir_p(TMP_DIR)
  Dir.chdir(TMP_DIR)
end

after do
  Dir.chdir(@initial_location)
  FileUtils.rm_rf(TMP_DIR)
end

def create_file(name)
  File.open(name, "w+")
end

RSpec.describe Loader do
  subject { Loader.json_file(path) }

  context "when provided a path to a json file" do
    let(:path) { "path/to/file.json" }

    it "returns json" do
      expect(subject).to be(true)
    end
  end

  context "when provided a path to a non-json file" do
    let(:path) { "path/to/file.xml" }

    it "errors out" do
      expect { subject }.to raise_error(Loader::InvalidFileTypeError)
    end
  end

  context "when provided an invalid path" do
    let(:path) { "this isn't actually a path" }

    it "errors out" do
      expect { subject }.to raise_error(Loader::InvalidPathError)
    end
  end
end
