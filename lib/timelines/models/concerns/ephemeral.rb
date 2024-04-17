require "active_support/concern"

module Timelines
  module Ephemeral
    extend ActiveSupport::Concern

    included do
      scope :draft, -> { where(started_at: nil) }
      scope :active, -> { where(ended_at: nil, started_at: [..Time.current]) }
      scope :active_at, ->(date) { where("started_at <= ? and ended_at IS ? OR ended_at >= ?", date, nil, date) }
      scope :with_deleted, -> { unscope(where: :ended_at) }
      scope :ended, -> { where.not(ended_at: nil) }
      scope :deleted, -> { ended }
      scope :not_deleted, -> { where(ended_at: nil) }

      def active?
        started? && !ended?
      end

      def active_at?(date)
        !!self.class.active_at(date).where(id: self.id)
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
