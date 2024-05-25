require "spec_helper"

module Timelines
  describe HasAuditTrail do
    let(:mock_resource) { build(:user) }

    it "returns an audit trail object" do
      expect(mock_resource.audit_trail).to be_an_instance_of ::Timelines::AuditTrail
    end
  end
end
