class AddNonceColumnToPings < ActiveRecord::Migration[5.1]
  def change
    add_column :pings, :nonce, :text, indexed: true
  end
end
