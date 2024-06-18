require "active_support/concern"

module Timelines
  module Ephemeral
    extend ActiveSupport::Concern

    included do
      scope :draft, -> { where(started_at: nil) }
      scope :active, -> { where(ended_at: nil, started_at: [..Time.current]) }
      scope :active_at, ->(date) { where("started_at <= ? AND (ended_at IS ? OR ended_at >= ?)", date, nil, date) }
      scope :with_deleted, -> { unscope(where: :ended_at) }
      scope :ended, -> { where.not(ended_at: nil) }
      scope :deleted, -> { ended }
      scope :not_deleted, -> { where(ended_at: nil) }

      def active?
        started? && !ended?
      end

      def active_at?(date)
        self.class.active_at(date).where(id: id).exists?
      end

      def start!
        return if started_at.present?

        update(started_at: Time.current)
      end

      def started?
        !!started_at&.past?
      end

      def end!
        return self if ended_at.present?

        result = ActiveRecord::Base.transaction do
          run_callbacks(:destroy) do
            update(ended_at: Time.current)
          end
        end

        result ? self : false
      end

      def ended?
        !!ended_at&.past?
      end

      def draft?
        !started?
      end

      def destroy
        end!
      end

      def destroy!
        end!
      end
    end
  end
end
