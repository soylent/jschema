# frozen_string_literal: true

require 'json'
require 'pathname'

# Fixture helper methods
module FixtureHelper
  # Build a fixture with a given name
  #
  # @param name [String] the fixture name
  # @return [Hash] the fixture
  def fixture(name)
    JSON.parse(read_fixture(name))
  end

  # Read a fixture with a given name
  #
  # @param name [String] the fixture name
  # @return [String] the fixture contents
  def read_fixture(name)
    filename = format('%<name>s.json', name: name)

    Pathname.new('fixtures').join(filename).expand_path(__dir__).read
  end
end
