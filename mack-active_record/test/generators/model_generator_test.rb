require File.dirname(__FILE__) + '/../test_helper.rb'

class ModelGeneratorTest < Test::Unit::TestCase
  
  def test_generate_data_mapper
    ModelGenerator.new("name" => "album").generate
    assert File.exists?(model_loc)
    assert_equal fixture("album.rb"), File.open(model_loc).read
    assert File.exists?(migration_loc)
  end
  
  def test_generate_data_mapper_with_columns
    ModelGenerator.new("name" => "albums", "cols" => "title:string,artist_id:integer,description:text").generate
    assert File.exists?(model_loc)
    assert_equal fixture("album.rb"), File.open(model_loc).read
    assert File.exists?(migration_loc)
  end
  
  def test_unit_test_created
    ModelGenerator.new("name" => "album").generate
    assert File.exists?(unit_test_loc)
    assert_equal fixture("album_unit_test.rb"), File.open(unit_test_loc).read
  end
  
  def unit_test_loc
    File.join(test_directory, "unit", "album_test.rb")
  end
  
  def model_loc
    File.join(models_directory, "album.rb")
  end
  
  def migration_loc
    File.join(migrations_directory, "001_create_albums.rb")
  end
  
end