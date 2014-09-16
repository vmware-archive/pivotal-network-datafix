class Datafix
  class Log < ActiveRecord::Base
    self.table_name = "datafix_log"
  end
end
