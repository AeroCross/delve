# frozen_string_literal: true

require "byebug"
require "fakefs/spec_helpers"
require_relative "../../lib/loader.rb"

def create_file(name)
  dirname = File.dirname(name)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end
  File.open(name, "w+")
end

RSpec.describe Loader do
  include FakeFS::SpecHelpers
  subject { Loader.json_file(path) }

  context "when provided a path to a json file" do
    before do
      create_file(path)
    end

    let(:path) { "/path/to/file.json" }

    it "returns json" do
      expect(subject).to be(true)
    end
  end

  context "when provided a path to a non-json file" do
    before do
      create_file(path)
    end

    let(:path) { "/path/to/file.xml" }

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
