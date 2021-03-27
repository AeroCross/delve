# frozen_string_literal: true

# Requiring pretty-print (pp) at the beginning prevents a TypeError with FakeFS
# See: https://github.com/fakefs/fakefs#fakefs-----typeerror-superclass-mismatch-for-class-file
require "pp"
require "fakefs/spec_helpers"
require_relative "../../lib/loader.rb"

def create_file(name)
  dirname = File.dirname(name)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end
  File.open(name, "w+")
end

def create_json_file(name)
  json = { foo: "bar" }.to_json
  create_file(name).write(json)
end

RSpec.describe Loader do
  include FakeFS::SpecHelpers
  subject { Loader.json_file(path).data }

  describe "#call" do
    context "when provided a path to a json file" do
      before do
        create_json_file(path)
      end

      let(:path) { "/path/to/file.json" }

      it "returns json" do
        expect(subject).to have_key(:foo)
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
end
