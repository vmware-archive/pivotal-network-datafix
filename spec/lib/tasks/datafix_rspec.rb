require "spec_helper"
require "rake"
require "rails/generators"
require "generators/datafix/datafix_generator"

describe "datafix rake tasks" do
  let(:fix_name) { "fix_kittens" }

  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/db/datafix"
    Rake::Task.define_task(:environment)

    @old_path = Dir.pwd
    Dir.chdir(Rails.root)
    Rails::Generators.invoke("datafix", [fix_name])
  end

  after(:all) do
    Dir.chdir(@old_path)
    @old_path = nil
  end

  describe "up" do
    it "runs the migration" do
      require Dir.glob(Rails.root.join("db/datafixes/*_#{fix_name}.rb")).first
      Datafixes::FixKittens.should_receive(:up)
      ENV['NAME'] = fix_name
      @rake["db:datafix:up"].invoke
    end
  end

  describe "down" do
    it "runs the migration" do
      require Dir.glob(Rails.root.join("db/datafixes/*_#{fix_name}.rb")).first
      Datafixes::FixKittens.should_receive(:down)
      ENV['NAME'] = fix_name
      @rake["db:datafix:down"].invoke
    end
  end
end
