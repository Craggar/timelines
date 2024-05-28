class User < ApplicationRecord
  include Timelines::HasEvents
  include Timelines::HasAuditTrail
  include Timelines::Ephemeral
  attribute :started_at, :datetime, default: -> { Time.current }

  def email
    @email ||= Faker::Internet.email
  end
end
