module Timelines
  class EventLogger < ::ActiveJob::Base
    queue_as :default

    def perform(actor_type, actor_id, resource_klass, resource_id, event, timestamp = Time.current)
      actor = actor_type.constantize.find_by(id: actor_id)
      resource = resource_klass.constantize.find_by(id: resource_id)
      return unless actor.present? && resource.present? && event.present?

      ::Timelines::Event.create!(actor: actor, resource: resource, event: event, created_at: timestamp)
    rescue => e
      Rails.logger.error("Failed to log event: #{e.message} - #{actor_type} #{actor_id} - #{resource_klass} #{resource_id} - #{event}")
      raise e
    end
  end
end
