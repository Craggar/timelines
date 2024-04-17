require "spec_helper"

module Timelines
  describe Event, type: :model do
    describe "associations" do
      it { is_expected.to belong_to(:actor).optional(true) }
      it { is_expected.to belong_to(:resource).optional(true) }
    end
  end
end
