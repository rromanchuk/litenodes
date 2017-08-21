class AddUuidType < ActiveRecord::Migration[5.1]
  def change
    drop_table :node_snapshots
    create_table :node_snapshots, id: :uuid do |t|
      t.belongs_to :node, type: :uuid, index: true
      t.belongs_to :snapshot, type: :uuid, index: true
    end
  end
end
