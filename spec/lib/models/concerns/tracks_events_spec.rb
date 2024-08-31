require "spec_helper"

module Timelines
  describe HasAuditTrail do
    let(:user_id) { SecureRandom.uuid }
    let(:mock_resource) { build(:user, id: user_id) }

    it "calls the event logger on an appropriate event" do
      freeze_time do
        expect(::Timelines::EventLogger).to receive(:perform_later).with("User", user_id, "User", user_id, "user::created", Time.current)
        mock_resource.save
      end
    end
  end
end
