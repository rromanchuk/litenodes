class AddIndexToAddress < ActiveRecord::Migration[5.1]
  def change
    add_index :nodes, :address
  end
end
