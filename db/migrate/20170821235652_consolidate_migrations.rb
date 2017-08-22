class ConsolidateMigrations < ActiveRecord::Migration[5.1]
  def change
    enable_extension "plpgsql"
    enable_extension "pgcrypto"
    enable_extension "uuid-ossp"

    execute <<-SQL
      CREATE TYPE ip_version_type AS ENUM ('ipv4', 'ipv6', 'onion');
    SQL

    create_table "alerts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.text "email"
      t.bigint "node_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["node_id"], name: "index_alerts_on_node_id"
    end

    create_table "node_snapshots", id: false, force: :cascade do |t|
      t.uuid "node_id"
      t.uuid "snapshot_id"
      t.index ["node_id"], name: "index_node_snapshots_on_node_id"
      t.index ["snapshot_id"], name: "index_node_snapshots_on_snapshot_id"
    end

    create_table "snapshots", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.integer "height"
      t.datetime "crawled_at"
      t.integer "num_nodes"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

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
      t.text :country_friendly_name
      t.timestamp :snapshot_at
      t.timestamps
    end
    add_column :nodes, :ip_version, :ip_version_type

  end
end
