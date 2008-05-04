namespace :db do
  
  desc "Create the database for your environment."
  task :create => :environment do
    drop_create_database
  end
  
  desc "Creates your Full environment. Does NOT create your production database!"
  task :create_all => :environment do
    drop_create_database("development")
    drop_create_database("test")
    ActiveRecord::Base.establish_connection(Mack::Configuration.database_configurations["development"])
    Rake::Task["db:migrate"].invoke
  end
  
  # desc "Returns the current schema version"
  # task :version => :environment do
  #   puts "Current version: " << ActiveRecord::Migrator.current_version.to_s
  # end 
  
end

private

def drop_create_database(env = MACK_ENV)
  abcs = Mack::Configuration.database_configurations
  case abcs[env]["adapter"]
    when "mysql"
      ActiveRecord::Base.establish_connection(
        :adapter => "mysql",
        :host => "localhost",
        :database => "mysql",
        :username => ENV["DB_USERNAME"] || "root",
        :password => ENV["DB_PASSWORD"] || ""
      )
      begin
        ActiveRecord::Base.connection.recreate_database(abcs[env]["database"])
      rescue Exception => e
      end
      begin
        ActiveRecord::Base.clear_active_connections!
      rescue Exception => e
      end
    when "postgresql"
      ENV['PGHOST']     = abcs[env]["host"] if abcs[env]["host"]
      ENV['PGPORT']     = abcs[env]["port"].to_s if abcs[env]["port"]
      ENV['PGPASSWORD'] = abcs[env]["password"].to_s if abcs[env]["password"]
      enc_option = "-E #{abcs[env]["encoding"]}" if abcs[env]["encoding"]

      ActiveRecord::Base.clear_active_connections!
      begin
        puts `dropdb -U "#{abcs[env]["username"]}" #{abcs[env]["database"]}`
      rescue Exception => e
      end
      
      begin
        puts `createdb #{enc_option} -U "#{abcs[env]["username"]}" #{abcs[env]["database"]}`
      rescue Exception => e
      end
    when 'sqlite3'
      FileUtils.rm_rf(abcs[env]["database"])
    else
      raise "Task not supported by '#{abcs[env]["adapter"]}'"
  end
end