class RecreateJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes_snapchats, id: false do |t|
      t.belongs_to :node, index: true
      t.belongs_to :snapshot, index: true
    end
    drop_table :snapshots_nodes
  end
end
