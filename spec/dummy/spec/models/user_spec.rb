require "spec_helper"

describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:events) }

    it_behaves_like "it is historical through Timelines::Ephemeral" do
      let(:factory_name) { :user_with_events }
    end
  end
end
