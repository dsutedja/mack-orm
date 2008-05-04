require File.dirname(__FILE__) + '/../test_helper.rb'

class ScaffoldGeneratorTest < Test::Unit::TestCase
  
  def test_generate_data_mapper
    sg = ScaffoldGenerator.run("name" => "zoo")
    File.open(File.join(MACK_CONFIG, "routes.rb")) do |f|
      assert_match "r.resource :zoos # Added by rake generate:scaffold name=zoo", f.read
    end
    
    assert File.exists?(views_directory)
    assert_equal fixture("zoo_no_cols", "edit.html.erb"), File.open(File.join(views_directory, "edit.html.erb")).read
    assert_equal fixture("zoo_no_cols", "index.html.erb"), File.open(File.join(views_directory, "index.html.erb")).read
    assert_equal fixture("zoo_no_cols", "new.html.erb"), File.open(File.join(views_directory, "new.html.erb")).read
    assert_equal fixture("zoo_no_cols", "show.html.erb"), File.open(File.join(views_directory, "show.html.erb")).read
    
    assert File.exists?(model_file)
    assert File.exists?(controller_file)
    assert File.exists?(migration_file)
    assert File.exists?(functional_test_file)
    assert_equal fixture("zoo_with_cols", "zoos_controller.rb"), File.open(controller_file).read
    assert_equal fixture("zoo.rb"), File.open(model_file).read
  end
  
  def test_generate_data_mapper_with_columns
    sg = ScaffoldGenerator.run("name" => "zoo", "cols" => "name:string,description:text,created_at:datetime,updated_at:datetime")
    File.open(File.join(MACK_CONFIG, "routes.rb")) do |f|
      assert_match "r.resource :zoos # Added by rake generate:scaffold name=zoo", f.read
    end
    assert File.exists?(views_directory)
    assert_equal fixture("zoo_with_cols", "edit.html.erb"), File.open(File.join(views_directory, "edit.html.erb")).read
    assert_equal fixture("zoo_with_cols", "index.html.erb"), File.open(File.join(views_directory, "index.html.erb")).read
    assert_equal fixture("zoo_with_cols", "new.html.erb"), File.open(File.join(views_directory, "new.html.erb")).read
    assert_equal fixture("zoo_with_cols", "show.html.erb"), File.open(File.join(views_directory, "show.html.erb")).read

    assert File.exists?(model_file)
    assert File.exists?(controller_file)
    assert File.exists?(migration_file)
  end
  
  def functional_test_file
    File.join(test_directory, "functional", "zoos_controller_test.rb")
  end
  
  def views_directory
    File.join(MACK_VIEWS, "zoos")
  end
  
  def model_file
    File.join(MACK_APP, "models", "zoo.rb")
  end
  
  def controller_file
    File.join(MACK_APP, "controllers", "zoos_controller.rb")
  end
  
  def migration_file
    File.join(migrations_directory, "001_create_zoos.rb")
  end
  
end