require "active_support/concern"

module Timelines
  module HasEvents
    extend ActiveSupport::Concern

    included do
      has_many :events, class_name: "Timelines::Event", as: :resource, dependent: :destroy
    end
  end
end
