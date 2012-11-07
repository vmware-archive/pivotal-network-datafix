require "spec_helper"

class Datafixes::FixKittens < Datafix
  def self.up
    table_name = Kitten.table_name
    archive_table(table_name)
    execute %Q{ UPDATE #{table_name} SET fixed = 't'; }
  end

  def self.down
    table_name = Kitten.table_name
    revert_archive_table(table_name)
  end
end

describe Datafix do

  let(:kitten_names) { %w[nyan hobbes stimpy tigger garfield] }
  let(:table_name) { Kitten.table_name }
  let(:archived_table_name) { "archived_#{table_name}" }

  before do
    kitten_names.each do |name|
      Kitten.create!(name: name)
    end
    Kitten.where(fixed: true).should be_empty
  end

  context "after running fix kittens up" do
    before do
      Datafixes::FixKittens.migrate('up')
    end

    it "fixes all kittens should" do
      Kitten.where(fixed: false).should be_empty
    end

    it "creates a kittens archive table" do
      Kitten.connection.table_exists?(archived_table_name).should be_true
      Kitten.connection.select_value("SELECT COUNT(*) FROM #{archived_table_name}").to_i.should == kitten_names.size
    end

    it "updates the datafix log" do
      datafix_log = DatafixLog.last
      datafix_log.direction.should == 'up'
      datafix_log.script.should == 'FixKittens'
    end

    context "after running fix kittens down" do
      before do
        Datafixes::FixKittens.migrate('down')
      end

      it "unfixes the kittens" do
        Kitten.where(fixed: true).should be_empty
      end

      it "removes the kittens archive table" do
        Kitten.connection.table_exists?("archived_kittens").should be_false
      end

      it "updates the datafix log" do
        datafix_log = DatafixLog.last
        datafix_log.direction.should == 'down'
        datafix_log.script.should == 'FixKittens'
      end
    end
  end
end
