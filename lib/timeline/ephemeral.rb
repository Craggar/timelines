require "active_support/concern"

module Timeline
  module Ephemeral
    extend ActiveSupport::Concern

    included do
      scope :draft, -> { where(started_at: nil) }
      scope :active, -> { where(ended_at: nil, started_at: [..Time.current]) }
      scope :with_deleted, -> { unscope(where: :ended_at) }
      scope :ended, -> { where.not(ended_at: nil) }
      scope :deleted, -> { ended }
      scope :not_deleted, -> { where(ended_at: nil) }
      attribute :started_at, default: -> { Time.current }

      def active?
        started? && !ended?
      end

      def start!
        return if started_at.present?

        update(started_at: Time.current)
      end

      def started?
        !!started_at&.past?
      end

      def end!
        destroy
      end

      def ended?
        !!ended_at&.past?
      end

      def draft?
        !started?
      end

      def destroy
        return if ended_at.present?

        update(ended_at: Time.current)
      end

      def self.destroy_all
        where(ended_at: nil).update_all(ended_at: Time.current)
      end
    end
  end
end
