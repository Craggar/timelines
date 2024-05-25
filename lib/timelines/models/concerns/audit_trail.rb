module Timelines
  class AuditTrail
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :resource
    attribute :reverse
    attribute :events

    def events
      reverse ? resource.events.reverse : resource.events
    end
  end
end
