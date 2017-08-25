# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170825200555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"
  enable_extension "uuid-ossp"

  create_table "alerts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text "email"
    t.bigint "node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["node_id"], name: "index_alerts_on_node_id"
  end

  create_table "node_snapshots", force: :cascade do |t|
    t.uuid "node_id"
    t.uuid "snapshot_id"
    t.index ["node_id"], name: "index_node_snapshots_on_node_id"
    t.index ["snapshot_id"], name: "index_node_snapshots_on_snapshot_id"
  end

# Could not dump table "nodes" because of following StandardError
#   Unknown type 'ip_version_type' for column 'ip_version'

  create_table "snapshots", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "height"
    t.datetime "crawled_at"
    t.integer "num_nodes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
