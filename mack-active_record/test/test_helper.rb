require "test/unit"
require File.join(File.dirname(__FILE__), "..", "..", "test_helpers")

$genosaurus_output_directory = File.join(File.dirname(__FILE__), "..", "tmp")

Object::MACK_CONFIG = File.dirname(__FILE__) unless Object.const_defined?("MACK_CONFIG")
Object::MACK_ROOT = $genosaurus_output_directory unless Object.const_defined?("MACK_ROOT")
Object::MACK_APP = File.join($genosaurus_output_directory, "app") unless Object.const_defined?("MACK_APP")
Object::MACK_ENV = "test" unless Object.const_defined?("MACK_ENV")
Object::MACK_VIEWS = File.join(MACK_APP, "views") unless Object.const_defined?("MACK_VIEWS")

require File.join(File.dirname(__FILE__), "..", "lib", "mack-active_record")
require File.join(File.dirname(__FILE__), "..", "..", "mack-orm_common", "lib", "mack-orm_common")


load File.join(File.dirname(__FILE__), "lib", "user.rb")

class Test::Unit::TestCase
  
  # place common methods, assertions, and other type things in this file so
  # other tests will have access to them.
  
  def cleanup
    ActiveRecord::Base.clear_active_connections!
    FileUtils.rm_rf($genosaurus_output_directory)
    FileUtils.rm_rf(File.join(MACK_CONFIG, "routes.rb"))
  end
  
  def teardown
    cleanup
  end
  
  def setup
    ActiveRecord::Base.clear_active_connections!
    [$genosaurus_output_directory, migrations_directory, models_directory].each do |d|
      FileUtils.mkdir_p(d)
    end
    FileUtils.cp(fixture_path("routes.rb"), File.join(MACK_CONFIG, "routes.rb"))
  end
  
  def migrations_directory
    File.join($genosaurus_output_directory, "db", "migrations")
  end
  
  def models_directory
    File.join($genosaurus_output_directory, "app", "models")
  end
  
  def test_directory
    File.join($genosaurus_output_directory, "test")
  end
  
  def fixture_path(*name)
    path = [File.dirname(__FILE__), "fixtures"]
    path << name
    path.flatten!
    File.join(path) + ".fixture"
  end
  
  def fixture(*name)
    File.open(fixture_path(name)).read
  end
  
end
