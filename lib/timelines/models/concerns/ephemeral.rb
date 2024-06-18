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
        destroy
      end

      def ended?
        !!ended_at&.past?
      end

      def draft?
        !started?
      end

      def destroy
        return self if ended_at.present?

        result = ActiveRecord::Base.transaction do
          run_callbacks(:destroy) do
            update(ended_at: Time.current)
            destroy_dependent_associations
          end
        end
        result ? self : false
      end

      def destroy!
        destroy
      end

      def self.destroy_all
        where(ended_at: nil).each(&:destroy)
      end

      def self.dependent_associations
        reflect_on_all_associations.select do |reflection|
          reflection.options[:dependent].present?
        end
      end

      private

      def destroy_dependent_associations
        self.class.dependent_associations.each do |reflection|
          method = if reflection.options[:dependent] == :destroy
            if reflection.collection?
              :destroy_all
            else
              :destroy
            end
          elsif reflection.options[:dependent] == :delete_all
            if reflection.collection?
              :delete_all
            else
              :delete
            end
          end
          send(reflection.name)&.send(method)
        end
      end
    end
  end
end
