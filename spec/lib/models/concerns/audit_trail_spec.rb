require "spec_helper"

module Timelines
  describe AuditTrail, type: :model do
    let(:mock_resource) { build(:user) }

    describe "#events" do
      let(:mock_events) {
        [
          {event: "first"},
          {event: "second"},
          {event: "third"}
        ]
      }

      before { allow(mock_resource).to receive(:events).and_return mock_events }

      it "returns events in chronological order" do
        expect(mock_resource.audit_trail.events).to eq mock_events
      end

      it "returns events in reverse order" do
        expect(mock_resource.audit_trail(reverse: true).events).to eq mock_events.reverse
      end
    end

    describe "#resource" do
      it "returns the resource" do
        expect(mock_resource.audit_trail.resource).to eq mock_resource
      end
    end
  end
end
