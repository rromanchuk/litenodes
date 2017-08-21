class RenameNodesSnapshots < ActiveRecord::Migration[5.1]
  def change
    rename_table :nodes_snapchats, :node_snapshots

  end
end
