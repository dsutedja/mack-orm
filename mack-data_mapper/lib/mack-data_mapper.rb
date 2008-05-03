require 'rubygems'
require 'genosaurus'
require 'erubis'
begin
  require 'mack-orm_common'
rescue Exception => e
end

gem("datamapper", "0.3.2")
require 'data_mapper'

dbs = YAML::load(Erubis::Eruby.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)

unless dbs.nil?
  settings = dbs[MACK_ENV]
  settings.symbolize_keys!
  if settings[:default]
    settings.each do |k,v|
      DataMapper::Database.setup(k, v.symbolize_keys)
    end
  else
    DataMapper::Database.setup(settings)
  end
end

class SchemaInfo # :nodoc:
  include DataMapper::Persistence
  
  set_table_name "schema_info"
  property :version, :integer, :default => 0
end

[:helpers, :migration_generator, :model_generator, :scaffold_generator].each do |folder|
  Dir.glob(File.join(File.dirname(__FILE__), folder.to_s, "**/*.rb")).each {|f| require f}
end
# Dir.glob(File.join(File.dirname(__FILE__), "tasks", "**/*.rake")).each {|f| load f} 