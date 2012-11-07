require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'database_cleaner'
require 'pry'

require 'pg'
require 'datafix'

PG_SPEC = {
  :adapter  => 'postgresql',
  :host     => 'localhost',
  :database => 'datafix_test',
  :username => ENV['USER'],
  :encoding => 'utf8'
}

ActiveRecord::Base.establish_connection(PG_SPEC.merge('database' => 'postgres', 'schema_search_path' => 'public'))
# drops and create need to be performed with a connection to the 'postgres' (system) database
# drop the old database (if it exists)
ActiveRecord::Base.connection.drop_database PG_SPEC[:database] rescue nil
# create new
ActiveRecord::Base.connection.create_database(PG_SPEC[:database])
ActiveRecord::Base.establish_connection(PG_SPEC)

ActiveRecord::Migration.create_table :datafix_log do |t|
  t.string :direction
  t.string :script
  t.timestamp :timestamp
end

class DatafixLog < ActiveRecord::Base
  self.table_name = "datafix_log"
end

ActiveRecord::Migration.create_table :kittens do |t|
  t.string :name
  t.boolean :fixed, default: false
  t.timestamps
end

class Kitten < ActiveRecord::Base; end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
