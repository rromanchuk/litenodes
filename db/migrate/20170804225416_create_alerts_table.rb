class CreateAlertsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts_tables, id: :uuid, default: -> { "uuid_generate_v4()" }, force: true  do |t|
      t.text :email
      t.timestamps
    end
  end
end
