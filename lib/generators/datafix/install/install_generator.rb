require 'rails/generators/active_record'

class Datafix
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      # Implement the required interface for Rails::Generators::Migration.

      source_root File.expand_path("../templates", __FILE__)

      def generate
        migration_dir = "db/migrate"
        migration_name = "create_datafix_log"
        if ActiveRecord::Generators::Base.migration_exists?(migration_dir, migration_name)
          raise "Another migration is already named #{migration_name}: #{migration_dir}"
        else
          migration_number = ActiveRecord::Generators::Base.next_migration_number(migration_dir)
          copy_file "migration.rb", "#{migration_dir}/#{migration_number}_#{migration_name}.rb"
        end
      end

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end
    end
  end
end
