require 'rubygems'
require 'genosaurus'
require 'erubis'
begin
  require 'mack-orm_common'
rescue Exception => e
end

require 'activerecord'

dbs = YAML::load(Erubis::Eruby.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)

unless dbs.nil?
  ActiveRecord::Base.establish_connection(dbs[MACK_ENV])
  class SchemaInfo < ActiveRecord::Base # :nodoc:
    set_table_name 'schema_info'
  end
end
[:helpers, :migration_generator, :model_generator, :scaffold_generator].each do |folder|
  Dir.glob(File.join(File.dirname(__FILE__), folder.to_s, "**/*.rb")).each {|f| require f}
end
# Dir.glob(File.join(File.dirname(__FILE__), "tasks", "**/*.rake")).each {|f| load f} 