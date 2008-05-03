require 'rubygems'
require 'rake'
module Mack
  module ORM
    module Test
      module Helpers
        
        # Runs the given rake task. Takes an optional hash that mimics command line parameters.
        def rake_task(name, env = {}, tasks = $current_rake_task)
          # set up the Rake application
          rake = Rake::Application.new
          Rake.application = rake
          load(File.join(File.dirname(__FILE__), "mack_env.rake"))
          load(tasks)

          # save the old ENV so we can revert it
          old_env = ENV.to_hash
          # add in the new ENV stuff
          env.each_pair {|k,v| ENV[k.to_s] = v}

          begin
            # run the rake task
            rake[name].invoke

            # yield for the tests
            yield if block_given?

          rescue Exception => e
            raise e
          ensure
            # empty out the ENV
            ENV.clear
            # revert to the ENV before the test started
            old_env.to_hash.each_pair {|k,v| ENV[k] = v}

            # get rid of the Rake application
            Rake.application = nil
          end
        end
        
      end
    end
  end
end

Test::Unit::TestCase.send(:include, Mack::ORM::Test::Helpers)