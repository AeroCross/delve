# frozen_string_literal: true

require "json"
require_relative "./json_loader"

class Loader
  class InvalidFileTypeError < StandardError; end
  class InvalidPathError < StandardError; end

  attr_reader :path

  def self.json_file(path)
    new(path).json_file
  end

  def initialize(path)
    @path = path
  end

  def json_file
    JSONLoader.new(File.open(path)) if can_load_json_file?(path)
  end

  private

  def file_exists?(path)
    raise InvalidPathError unless File.exist?(path)
    true
  end

  def is_json?(path)
    raise InvalidFileTypeError unless path.end_with?(".json")
    true
  end

  def can_load_json_file?(path)
    file_exists?(path) && is_json?(path)
  end
end
