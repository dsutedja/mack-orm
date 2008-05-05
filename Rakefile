require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'

GEMS = %w{mack-orm_common mack-active_record mack-data_mapper}

namespace :install do
  
  task :all do
    GEMS.each do |gem|
      sh("cd #{gem} && rake install")
    end
  end
  
end