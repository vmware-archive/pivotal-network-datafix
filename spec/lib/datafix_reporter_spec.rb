require 'spec_helper'
require 'datafix/reporter'

describe Datafix::Reporter do

  let(:migration_root) { Dir::mktmpdir }
  let(:reporter) { described_class.new(migration_root) }

  after do
    FileUtils.rm_rf(migration_root)
  end

  describe '#status' do

    before do
      FileUtils.touch(File.join(migration_root, '20130101000000_pending_datafix.rb'))

      FileUtils.touch(File.join(migration_root, '20140101000000_create_users.rb'))
      Datafix::Log.create(direction: 'up', script: 'CreateUsers', timestamp: Time.parse('2014-01-02T01:02:03'))
      Datafix::Log.create(direction: 'down', script: 'CreateUsers', timestamp: Time.parse('2014-01-02T04:05:06'))
    end

    subject { reporter.status }

    it 'returns migrations with the expected states' do
      expect(subject).to eq [
        Datafix::Reporter::Entry.new('pending', 'pending_datafix', nil),
        Datafix::Reporter::Entry.new('down', 'create_users', Time.parse('2014-01-02T04:05:06'))
      ]
    end

  end


end
