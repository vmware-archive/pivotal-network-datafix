class Datafix
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/db/datafix.rake"
    end

    initializer 'datafix.load_datafix_models' do
      require  "datafix/log"
      require  "datafix/reporter"
    end
  end
end
