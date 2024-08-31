require "active_support/concern"

module Timelines
  module TracksEvents
    extend ActiveSupport::Concern

    included do
      def self.tracks_timelines_event(name, actor:, resource:, event:, conditions:)
        method_name = "track_#{name}_event"
        define_method method_name.to_sym do
          event_should_be_logged = conditions.call(self)
          return unless event_should_be_logged

          event_actor = actor.call(self)
          event_resource = resource.call(self)
          event_summary = event.call(self)
          return unless event_actor.present? && event_resource.present? && event_summary.present?

          ::Timelines::EventLogger.perform_later(event_actor.class.name, event_actor.id, event_resource.class.name, event_resource.id, event_summary, Time.current)
        end

        before_save method_name.to_sym
      end
    end
  end
end
