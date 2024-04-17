module Timelines
  class Event < ActiveRecord::Base
    self.table_name = "timelines_events"

    belongs_to :actor, polymorphic: true
    belongs_to :resource, polymorphic: true
  end
end
