class AddSnapshotAtColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :nodes, :snapshot_at, :timestamp

  end
end
