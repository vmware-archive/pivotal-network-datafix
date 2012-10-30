class DatafixGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  PATH = 'db/datafixes'

  def generate
    raise "Datafix with name '#{file_name}' already exists" if Dir.glob("#{PATH}/*_#{file_name}.rb").any?

    template "datafix_template.rb.erb", "#{PATH}/#{timestamp}_#{file_name}.rb"
    template "datafix_spec_template.rb.erb", "spec/#{PATH}/#{timestamp}_#{file_name}_spec.rb"
  end

  def timestamp
    @timestamp ||= Time.now.strftime("%Y%m%d%H%M%S")
  end
end
