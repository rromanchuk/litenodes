class CreateSnapshotsNodesTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :alerts_tables
    drop_table :snapshots_tables

    create_table :snapshots, id: :uuid, default: -> { "uuid_generate_v4()" }, force: true do |t|
      t.integer :height
      t.timestamp :crawled_at
      t.integer :num_nodes
      t.timestamps
    end

    create_table :alerts, id: :uuid, default: -> { "uuid_generate_v4()" }, force: true  do |t|
      t.text :email
      t.belongs_to :node, index: true
      t.timestamps
    end

    create_table :snapshots_nodes, id: false do |t|
      t.belongs_to :node, index: true
      t.belongs_to :snapshot, index: true
    end
  end
end
