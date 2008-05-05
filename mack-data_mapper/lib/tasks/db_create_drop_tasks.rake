namespace :db do
  
  desc "Create the database for your environment."
  task :create => :environment do
    database(ENV["name"] || :default) do
      drop_create_database
    end
  end
  
  namespace :create do
    
    desc "Creates your Full environment. Does NOT create your production database!"
    task :all => :environment do
      database(ENV["name"] || :default) do
        drop_create_database("development")
      end
      database(ENV["name"] || :default) do
        drop_create_database("test")
      end
      Rake::Task["db:migrate"].invoke
    end
    
  end

end

private
def drop_create_database
  pp database
  configuration = database.adapter.instance_variable_get('@configuration')
  pp configuration
  
  DataMapper::Database.setup(:tmp, {
    :adapter => "mysql",
    :host => "localhost",
    :database => "mysql",
    :username => ENV["DB_USERNAME"] || "root",
    :password => ENV["DB_PASSWORD"] || ""
  })
  
  case database.adapter.class.name
    when "DataMapper::Adapters::MysqlAdapter"
      puts "configuration.database: #{configuration.database}"
      database(:tmp) do
        database.execute "DROP DATABASE IF EXISTS `#{configuration.database}`"
        database.execute "CREATE DATABASE `#{configuration.database}` DEFAULT CHARACTER SET `utf8`"
        begin
          database.adapter.flush_connections!
        rescue Exception => e
        end
      end
    when "postgresql"
      ENV['PGHOST']     = configuration.host if configuration.host
      ENV['PGPORT']     = configuration.port.to_s if configuration.port
      ENV['PGPASSWORD'] = configuration.password.to_s if configuration.password

      database.adapter.flush_connections!
      begin
        puts `dropdb -U "#{configuration.username}" #{configuration.database}`
      rescue Exception => e
      end
      
      begin
        puts `createdb -U "#{configuration.username}" #{configuration.database}`
      rescue Exception => e
      end
    when 'sqlite3'
      FileUtils.rm_rf(configuration.database)
    else
      raise "Task not supported for '#{database.adapter}'"
  end
end