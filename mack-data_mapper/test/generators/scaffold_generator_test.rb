require File.dirname(__FILE__) + '/../test_helper.rb'

class ScaffoldGeneratorTest < Test::Unit::TestCase
  
  def setup
    FileUtils.cp(fixture_path("routes.rb"), File.join(MACK_CONFIG, "routes.rb"))
  end
  
  def test_generate_data_mapper
    orm_common
    assert_equal fixture("zoo_with_cols", "zoos_controller.rb"), File.open(controller_file).read
    assert_equal fixture("zoo_with_cols", "zoo.rb"), File.open(model_file).read
  end
  
  def test_generate_data_mapper_with_columns
    orm_common_with_cols
  end
  
  def orm_common_with_cols
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
  
  def orm_common
    sg = ScaffoldGenerator.run("name" => "zoo")
    File.open(File.join(MACK_CONFIG, "routes.rb")) do |f|
      assert_match "r.resource :zoos # Added by rake generate:scaffold name=zoo", f.read
    end
    
    assert File.exists?(views_directory)
    assert_equal fixture("zoo_no_cols", "edit.html.erb"), File.open(File.join(views_directory, "edit.html.erb")).read
    
    index_erb = <<-ERB
<h1>Listing Zoos</h1>

<table>
  <tr>
    <th>&nbsp;</th>
  </tr>

<% for zoo in @zoos %>
  <tr>
    <td>&nbsp;</td>
    <td><%= link_to("Show", zoos_show_url(:id => zoo.id)) %></td>
    <td><%= link_to("Edit", zoos_edit_url(:id => zoo.id)) %></td>
    <td><%= link_to("Delete", zoos_delete_url(:id => zoo.id), :method => :delete, :confirm => "Are you sure?") %></td>
  </tr>
<% end %>
</table>

<br />

<%= link_to("New Zoo", zoos_new_url) %>
ERB
    assert_equal index_erb, File.open(File.join(views_directory, "index.html.erb")).read
    
    new_erb = <<-ERB
<h1>New Zoo</h1>

<%= error_messages_for :zoo %>

<% form(zoos_create_url, :class => "new_zoo", :id => "new_zoo") do %>
  <p>
    <input id="zoo_submit" name="commit" type="submit" value="Create" />
  </p>
<% end %>

<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal new_erb, File.open(File.join(views_directory, "new.html.erb")).read
    
    show_erb = <<-ERB
<p>
  <h1>Zoo</h1>
</p>

<%= link_to("Edit", zoos_edit_url(:id => @zoo.id)) %> |
<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal show_erb, File.open(File.join(views_directory, "show.html.erb")).read
    
    assert File.exists?(model_file)
    assert File.exists?(controller_file)
    assert File.exists?(migration_file)
    assert File.exists?(functional_test_file)
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