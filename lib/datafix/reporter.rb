require 'datafix/log'

class Datafix

  class Reporter

    class Entry
      attr_reader :status, :name, :last_run

      def initialize(status, name, last_run)
        @status = status
        @name = name
        @last_run = last_run
      end

      def ==(other)
        status == other.status && \
          name == other.name && \
          last_run == other.last_run
      end
      alias_method :eql?, :==

    end

    def initialize(migration_root=Rails.root.join('db', 'datafixes'))
      @migration_root = Pathname(migration_root)
    end

    def status
      assert_datafix_log_exists!

      migration_root.children.map do |child|
        if match_data = /^(\d{3,})_(.+)\.rb$/.match(child.basename.to_s)
          script = match_data[2]
          last_run = Datafix::Log.order(:id).where(script: script.camelize).last

          Entry.new(
            last_run ? last_run.direction : 'pending',
            script,
            last_run ? last_run.timestamp : nil
          )
        end
      end.compact
    end

    private

    attr_reader :migration_root

    def assert_datafix_log_exists!
      unless ActiveRecord::Base.connection.table_exists?(Datafix::Log.table_name)
        raise 'Data migrations table does not exist yet.'
      end
    end

  end
end
