class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name

      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
