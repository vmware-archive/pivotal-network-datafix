class DatafixGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  PATH = 'db/datafixes'

  def generate
    raise "Datafix with name '#{file_name}' already exists" if Dir.glob("#{PATH}/*_#{file_name}.rb").any?

    template "datafix_template.rb.erb", "#{PATH}/#{timestamp}_#{file_name}.rb"

    if Rails.application.config.generators.rails[:test_framework] == :rspec
      template "datafix_spec_template.rb.erb", "spec/#{PATH}/#{timestamp}_#{file_name}_spec.rb"
    else
      puts "Datafix test was not generated. Datafix requires rspec."
    end
  end

  def timestamp
    @timestamp ||= Time.now.strftime("%Y%m%d%H%M%S")
  end
end
