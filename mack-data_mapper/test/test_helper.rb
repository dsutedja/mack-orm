require "test/unit"
require File.join(File.dirname(__FILE__), "..", "..", "test_helpers")

$genosaurus_output_directory = File.join(File.dirname(__FILE__), "..", "tmp")

Object::MACK_CONFIG = File.dirname(__FILE__) unless Object.const_defined?("MACK_CONFIG")
Object::MACK_ROOT = $genosaurus_output_directory unless Object.const_defined?("MACK_ROOT")
Object::MACK_APP = File.join($genosaurus_output_directory, "app") unless Object.const_defined?("MACK_APP")
Object::MACK_ENV = "test" unless Object.const_defined?("MACK_ENV")

require File.join(File.dirname(__FILE__), "..", "lib", "mack-data_mapper")


load File.join(File.dirname(__FILE__), "lib", "user.rb")

class Test::Unit::TestCase
  
  # place common methods, assertions, and other type things in this file so
  # other tests will have access to them.
  
  def cleanup
    database.adapter.flush_connections!
    FileUtils.rm_rf($genosaurus_output_directory)
    FileUtils.rm_rf(File.join(MACK_CONFIG, "routes.rb"))
  end
  
  def teardown
    cleanup
  end
  
  def setup
    database.adapter.flush_connections!
    [$genosaurus_output_directory, migrations_directory, models_directory].each do |d|
      FileUtils.mkdir_p(d)
    end
  end
  
  def migrations_directory
    File.join($genosaurus_output_directory, "db", "migrations")
  end
  
  def models_directory
    File.join($genosaurus_output_directory, "app", "models")
  end
  
  def fixture_path(name)
    File.join(File.dirname(__FILE__), "fixtures", name + ".fixture")
  end
  
end
