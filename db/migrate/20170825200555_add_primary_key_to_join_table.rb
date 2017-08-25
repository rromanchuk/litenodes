class AddPrimaryKeyToJoinTable < ActiveRecord::Migration[5.1]
  def change
    add_column :node_snapshots, :id, :primary_key
  end
end
