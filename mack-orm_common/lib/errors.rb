module Mack
  module Errors
    # Raised if there are migrations that need to be run before a task is performed.
    class UnrunMigrations < StandardError
      # Taks the number of migrations that need to be run.
      def initialize(number)
        super("You currently have #{number} #{number == 1 ? "migration" : "migrations"} that #{number == 1 ? "needs" : "need"} to be run.")
      end
      
    end
  end # Errors
end # Mack