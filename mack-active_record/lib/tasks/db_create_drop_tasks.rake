namespace :db do
  
  desc "Create the database for your environment."
  task :create => :environment do
    drop_create_database
  end
  
  namespace :create do
    
    desc "Creates your Full environment. Does NOT create your production database!"
    task :all => :environment do
      drop_create_database("development")
      drop_create_database("test")
      ActiveRecord::Base.establish_connection(Mack::Configuration.database_configurations["development"])
      Rake::Task["db:migrate"].invoke
    end
    
  end

end

private
def drop_create_database(env = MACK_ENV)
  abcs = Mack::Configuration.database_configurations
  db_settings = abcs[env]
  case db_settings["adapter"]
    when "mysql"
      ActiveRecord::Base.establish_connection(
        :adapter => "mysql",
        :host => "localhost",
        :database => "mysql",
        :username => ENV["DB_USERNAME"] || "root",
        :password => ENV["DB_PASSWORD"] || ""
      )
      
      if options[:collation]
        execute "CREATE DATABASE `#{name}` DEFAULT CHARACTER SET `#{options[:charset] || 'utf8'}` COLLATE `#{options[:collation]}`"
      else
        execute "CREATE DATABASE `#{name}` DEFAULT CHARACTER SET `#{options[:charset] || 'utf8'}`"
      end

      execute "DROP DATABASE IF EXISTS `#{name}`"
      
      begin
        ActiveRecord::Base.connection.recreate_database(db_settings["database"])
      rescue Exception => e
      end
      begin
        ActiveRecord::Base.clear_active_connections!
      rescue Exception => e
      end
    when "postgresql"
      ENV['PGHOST']     = db_settings["host"] if db_settings["host"]
      ENV['PGPORT']     = db_settings["port"].to_s if db_settings["port"]
      ENV['PGPASSWORD'] = db_settings["password"].to_s if db_settings["password"]
      enc_option = "-E #{db_settings["encoding"]}" if db_settings["encoding"]

      ActiveRecord::Base.clear_active_connections!
      begin
        puts `dropdb -U "#{db_settings["username"]}" #{db_settings["database"]}`
      rescue Exception => e
      end
      
      begin
        puts `createdb #{enc_option} -U "#{db_settings["username"]}" #{db_settings["database"]}`
      rescue Exception => e
      end
    when 'sqlite3'
      FileUtils.rm_rf(db_settings["database"])
    else
      raise "Task not supported by '#{db_settings["adapter"]}'"
  end
end