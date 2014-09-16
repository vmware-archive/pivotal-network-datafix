namespace :db do
  namespace :datafix do

    desc "Run the 'up' on the passed datafix"
    task :up => :environment do
      name = ENV['NAME']
      raise 'NAME required' if name.blank?

      require path_from_name(name)
      klass_from_name(name).migrate('up')
    end

    desc "Run the 'down' operation on the passed datafix"
    task :down => :environment do
      name = ENV['NAME']
      raise 'NAME required' if name.blank?

      require path_from_name(name)
      klass_from_name(name).migrate('down')
    end

    desc 'Display status of migrations'
    task :status => [:environment] do

      puts "\ndatabase: #{ActiveRecord::Base.connection_config[:database]}\n\n"
      puts "#{'Status'.center(8)}  #{'Last Run'.ljust(22)} Datafix Name"
      puts "-" * 80

      Datafix::Reporter.new.status.each do |datafix|
        last_run = datafix.last_run ? datafix.last_run.iso8601 : '(not run)'
        puts "#{datafix.status.center(8)}  #{last_run.ljust(22)} #{datafix.name}"
      end
      puts
    end
  end

  private

  def klass_from_name(name)
    name = name.split(File::SEPARATOR).last.gsub(/^\d+_/, '').gsub(/.rb$/, '').camelize
    "Datafixes::#{name}".constantize
  end

  def path_from_name(name)
    unless name =~ %r(^db/datafixes/)
      name = name.underscore
      name = Dir.glob("db/datafixes/*_#{name}.rb").first
    end
    Rails.root.join(name)
  end
end
