class AddIpvTypeColumn < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      CREATE TYPE ip_version_type AS ENUM ('ipv4', 'ipv6', 'onion');
    SQL
    add_column :nodes, :ip_version, :ip_version_type
    add_index :nodes, :ip_version
  end
end
