require File.dirname(__FILE__) + '/../test_helper.rb'

class DbTasksTest < Test::Unit::TestCase
  
  $current_rake_task = File.join(File.dirname(__FILE__), "..", "..", "lib", "tasks", "db_tasks.rake")
  
  def test_db_rollback
    test_db_migrate
    si = SchemaInfo.first
    assert_equal 2, si.version
    assert_equal 1, User.count
    rake_task("db:rollback")
    si = SchemaInfo.first
    assert_equal 1, si.version
    assert_equal 0, User.count
  end
  
  def test_db_rollback_two_steps
    test_db_migrate
    si = SchemaInfo.first
    assert_equal 2, si.version
    rake_task("db:rollback", "STEP" => "2")
    si = SchemaInfo.first
    assert_equal 0, si.version
    assert !User.table.exists?
  end
  
  def test_db_rollback_unrun_migrations
    test_db_migrate
    MigrationGenerator.run("name" => "create_comments")
    si = SchemaInfo.first
    assert_equal 2, si.version
    assert_raise(Mack::Errors::UnrunMigrations) { rake_task("db:rollback") }
  end

  def test_db_migrate
    assert !SchemaInfo.table.exists?
    rake_task("db:migrate") do
      assert SchemaInfo.table.exists?
      si = SchemaInfo.first
      assert_equal 0, si.version
    end
    FileUtils.cp(fixture_path("create_users_migration.rb"), File.join(migrations_directory, "001_create_users.rb"))
    assert !User.table.exists?
    rake_task("db:migrate")
    assert User.table.exists?
    si = SchemaInfo.first
    assert_equal 1, si.version
    FileUtils.cp(fixture_path("add_users_migration.rb"), File.join(migrations_directory, "002_add_users.rb"))
    assert_equal 0, User.count
    rake_task("db:migrate")
    assert_equal 1, User.count
    si = SchemaInfo.first
    assert_equal 2, si.version
  end
  
end