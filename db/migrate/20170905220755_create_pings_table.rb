class CreatePingsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :pings, id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.references :node, type: :uuid, null: false
      t.integer :rtt
      t.timestamps
    end
  end
end
