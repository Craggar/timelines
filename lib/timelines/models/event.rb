module Timelines
  class Event < ActiveRecord::Base
    belongs_to :actor, polymorphic: true
    belongs_to :resource, polymorphic: true

    self.table_name = "timelines_events"
  end
end
