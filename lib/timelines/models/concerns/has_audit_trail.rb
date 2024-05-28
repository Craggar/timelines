require "active_support/concern"

module Timelines
  module HasAuditTrail
    extend ActiveSupport::Concern

    def audit_trail(reverse: false)
      ::Timelines::AuditTrail.new(resource: self, reverse: reverse)
    end
  end
end
