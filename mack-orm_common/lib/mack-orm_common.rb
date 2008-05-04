require File.join(File.dirname(__FILE__), 'genosaurus_helpers')
require File.join(File.dirname(__FILE__), 'model_column')
require File.join(File.dirname(__FILE__), 'errors')

module Mack
  module Configuration
    
    def self.database_configurations
      YAML::load(Erubis::Eruby.new(IO.read(File.join(MACK_CONFIG, "database.yml"))).result)
    end
    
  end # Configuration
end # Mack
