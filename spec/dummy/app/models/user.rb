class User < ApplicationRecord
  include Timelines::HasEvents
  include Timelines::HasAuditTrail
  include Timelines::Ephemeral
  attribute :started_at, :datetime, default: -> { Time.current }

  tracks_timelines_event :user_created, on: :before_create, resource: ->(instance) { instance }, actor: ->(instance) { instance }, event: ->(instance) { "user::created" }, conditions: ->(instance) { true }

  def email
    @email ||= Faker::Internet.email
  end
end
