class CreateTimelinesEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :timelines_events, id: :uuid do |t|
      t.references :actor, type: :uuid, polymorphic: true
      t.references :resource, type: :uuid, polymorphic: true
      t.string :event
      t.timestamps
    end
  end
end
