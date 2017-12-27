class CreateMempoolTable < ActiveRecord::Migration[5.1]
  def change
    create_table :mempool, id: :uuid, default: -> { "uuid_generate_v4()" }, force: true do |t|
      t.text :txid
      t.integer :size
      t.integer :fee
      t.integer :modifiedfee
      t.timestamp :time
      t.integer :height
      t.integer :descendantcount
      t.integer :descendantsize
      t.integer :descendantfees
      t.integer :ancestorcount
      t.integer :ancestorsize
      t.integer :ancestorfees
    end
  end
end
