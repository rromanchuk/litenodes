class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    create_table :nodes, id: :uuid, default: -> { "uuid_generate_v4()" }, force: true do |t|
      t.integer :port
      t.integer :version
      t.text :user_agent, index: true
      t.integer :services
      t.integer :height
      t.timestamp :timestamp
      t.text :hostname
      t.text :city
      t.text :country, index: true
      t.decimal :latitude, {:precision=>10, :scale=>6}
      t.decimal :longitude, {:precision=>10, :scale=>6}
      t.text :timezone
      t.text :asn
      t.text :org
      t.inet :ip, index: true
      t.text :address
      t.timestamps
    end


  end
end
