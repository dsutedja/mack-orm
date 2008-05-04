# This will generate a migration for your application.
# 
# Example without columns:
#   rake generate:migration name=create_users
# 
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < ActiveRecord::Migration
#     self.up
#     end
# 
#     self.down
#     end
#   end
# 
# Example with columns:
#   rake generate:migration name=create_users cols=username:string,email_address:string,created_at:datetime,updated_at:datetime
# 
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < ActiveRecord::Migration
#     self.up
#       create_table :users do |t|
#         t.column :username, :string
#         t.column :email_address, :string
#         t.column :created_at, :datetime
#         t.column :updated_at, :datetime
#     end
# 
#     self.down
#       drop_table :users
#     end
#   end
class MigrationGenerator < Genosaurus

  require_param :name
  
  def setup
    @table_name = param(:name).underscore.plural.gsub("create_", "")
    @migration_name = "#{next_migration_number}_#{param(:name).underscore}"
  end
  
end