module Last
module Initializers

module Initializer
  # @param paths [Array<String>]
  #
  def self.run(paths:)
    load_environment
    load_paths(paths)
  end

  def self.load_environment
    Dotenv.load
    Dotenv.overload(".env.test") if ENV["RACK_ENV"] == "test"
  end

  def self.load_paths(paths)
    Utilities.require_file_and_tree_for_each(paths)
  end
end

module Initializer::Utilities
  def self.require_file(path)
    require "#{path}.rb" if File.exist?("#{path}.rb")
  end

  def self.require_tree(path)
    Dir.glob("#{path}/**/*.rb").sort.each(&method(:require)) if File.exist?(path)
  end

  def self.require_file_and_tree(path)
    require_file(path)
    require_tree(path)
  end

  def self.require_file_and_tree_for_each(array)
    array.each(&method(:require_file_and_tree))
  end
end

end
end
