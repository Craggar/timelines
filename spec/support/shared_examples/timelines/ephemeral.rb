# expects `factory_name` to be defined

RSpec.shared_examples "it is historical through Timelines::Ephemeral" do
  let(:instance) { build(factory_name) }

  describe "active?" do
    it "returns true if the record started in the past and has no ending" do
      instance.started_at = 1.day.ago
      expect(instance.active?).to be_truthy
    end

    it "returns true if the record started in the past and has an ending in the future" do
      instance.started_at = 1.day.ago
      instance.ended_at = 1.day.from_now
      expect(instance.active?).to be_truthy
    end

    it "returns false if the record started in the future" do
      instance.started_at = 1.day.from_now
      expect(instance.active?).to be_falsey
    end

    it "returns false if the record started in the past and has an ending in the past" do
      instance.started_at = 1.day.ago
      instance.ended_at = 1.day.ago
      expect(instance.active?).to be_falsey
    end

    it "returns false if the record has no starting date" do
      allow(instance).to receive(:started_at).and_return(nil)
      expect(instance.active?).to be_falsey
    end
  end

  describe "active_at?" do
    it "returns true if the record started before the given date and has no ending" do
      instance.update!(started_at: 1.day.ago)
      expect(instance.reload.active_at?(Time.current)).to be_truthy
    end

    it "returns true if the record started before the given date and has an ending in the future" do
      instance.update!(started_at: 1.day.ago)
      instance.ended_at = 1.day.from_now
      expect(instance.reload.active_at?(Time.current)).to be_truthy
    end

    it "returns false if the record started after the given date" do
      instance.update!(started_at: 1.day.from_now)
      expect(instance.reload.active_at?(Time.current)).to be_falsey
    end

    it "returns false if the record started before the given date and has an ending before the given date" do
      instance.update!(started_at: 1.day.ago, ended_at: 1.day.ago)
      expect(instance.reload.active_at?(Time.current)).to be_falsey
    end
  end

  describe "start!" do
    it "sets the starting date to the current time" do
      freeze_time do
        instance.started_at = nil
        expect { instance.start! }.to change { instance.started_at }.from(nil).to(Time.current)
      end
    end

    it "doesn't change the starting date if it's already set" do
      instance.started_at = 1.day.ago
      expect { instance.start! }.not_to change { instance.started_at }
    end
  end

  describe "started?" do
    it "returns true if the record has a starting date in the past" do
      instance.started_at = 1.day.ago
      expect(instance.started?).to be_truthy
    end

    it "returns false if the record has a starting date in the future" do
      instance.started_at = 1.day.from_now
      expect(instance.started?).to be_falsey
    end

    it "returns false if the record has no starting date" do
      allow(instance).to receive(:started_at).and_return(nil)
      expect(instance.started?).to be_falsey
    end
  end

  describe "end!" do
    it "sets the ending date to the current time" do
      freeze_time do
        instance.ended_at = nil
        expect { instance.end! }.to change { instance.ended_at }.from(nil).to(Time.current)
      end
    end
  end

  describe "ended?" do
    it "returns true if the record has an ending date in the past" do
      instance.ended_at = 1.day.ago
      expect(instance.ended?).to be_truthy
    end

    it "returns false if the record has an ending date in the future" do
      instance.ended_at = 1.day.from_now
      expect(instance.ended?).to be_falsey
    end

    it "returns false if the record has no ending date" do
      allow(instance).to receive(:ended_at).and_return(nil)
      expect(instance.ended?).to be_falsey
    end
  end

  describe "draft?" do
    it "returns true if the record has no starting date" do
      allow(instance).to receive(:started_at).and_return(nil)
      expect(instance.draft?).to be_truthy
    end

    it "returns true if the record has a starting date in the future" do
      instance.started_at = 1.day.from_now
      expect(instance.draft?).to be_truthy
    end

    it "returns false if the record has a starting date in the past" do
      instance.started_at = 1.day.ago
      expect(instance.draft?).to be_falsey
    end
  end

  describe "destroy" do
    let!(:instance) { create(factory_name) }

    it "doesn't delete the record" do
      expect { instance.destroy }.not_to change { described_class.unscoped.count }
    end

    it "sets the deleted at field" do
      freeze_time do
        expect { instance.destroy }.to change { instance.ended_at }.from(nil).to(Time.current)
      end
    end
  end

  describe "destroy!" do
    let!(:instance) { create(factory_name) }

    it "doesn't delete the record" do
      expect { instance.destroy! }.not_to change { described_class.unscoped.count }
    end

    it "sets the deleted at field" do
      freeze_time do
        expect { instance.destroy! }.to change { instance.ended_at }.from(nil).to(Time.current)
      end
    end

    it "returns if the record can't be destroyed" do
      allow_any_instance_of(described_class).to receive(:end!).and_return(false)
      expect(instance.destroy!).to eq(false)
    end
  end

  describe "destroy_all" do
    let(:record_count) { 5 }

    before do
      create_list(factory_name, record_count)
    end

    it "doesn't delete the record" do
      expect { described_class.destroy_all }.not_to change { described_class.unscoped.count }
    end

    it "sets the deleted at field" do
      freeze_time do
        expect(described_class.unscoped.pluck(:ended_at).uniq).to eq([nil])
        described_class.destroy_all
        expect(described_class.unscoped.pluck(:ended_at).uniq).to eq([Time.current])
      end
    end
  end
end
