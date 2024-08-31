require "spec_helper"

RSpec.describe Timelines::EventLogger, type: :job do
  describe "#perform - " do
    let(:queue_job) { described_class.perform_later(actor_type, actor_id, resource_klass, resource_id, event, timestamp) }
    let(:actor) { create(:user) }
    let(:actor_type) { "User" }
    let(:actor_id) { actor.id }
    let(:resource) { create(:user) }
    let(:resource_klass) { "User" }
    let(:resource_id) { resource.id }
    let!(:timestamp) { Time.current.beginning_of_day }
    let(:event) { "user:created" }

    context "Creating an event - " do
      it "Triggers an email to that user" do
        expect(Timelines::Event).to receive(:create!).with(actor: actor, resource: resource, event: event, created_at: timestamp)
        queue_job
        perform_enqueued_jobs
      end

      context "if there's an error saving the event" do
        before do
          expect(Timelines::Event).to receive(:create!).with(actor: actor, resource: resource, event: event, created_at: timestamp).and_raise(StandardError.new("Failed to save event"))
        end

        it "logs the error and raises it" do
          expect {
            queue_job
            perform_enqueued_jobs
          }.to raise_error(StandardError)
        end
      end
    end
  end
end
