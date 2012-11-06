module Datafix
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/db/datafix.rake"
    end
  end
end
