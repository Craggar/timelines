require "active_support/concern"

module Timelines
  module Ephemeral
    extend ActiveSupport::Concern

    included do
      scope :draft, -> { where(started_at: nil) }
      scope :active, -> { active_at(Time.current) }
      scope :active_at, ->(date) { where(started_at: [..date], ended_at: nil).or(where(started_at: [..date], ended_at: [date..])) }
      scope :with_deleted, -> { unscope(where: :ended_at) }
      scope :ended, -> { where(ended_at: [..Time.current]) }
      scope :deleted, -> { ended }
      scope :not_deleted, -> { where(ended_at: nil).or(where(ended_at: [Time.current..])) }

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
        return self if ended_at.present? && ended_at.past?

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
