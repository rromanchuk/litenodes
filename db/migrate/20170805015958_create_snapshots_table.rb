class CreateSnapshotsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :snapshots_tables, id: :uuid, default: -> { "uuid_generate_v4()" }, force: true do |t|
      t.integer :height
      t.timestamp :crawled_at
      t.integer :num_nodes
    end
  end
end
