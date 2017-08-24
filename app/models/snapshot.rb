class Snapshot < ApplicationRecord
  has_many :node_snapshots
  has_many :nodes, through: :node_snapshots

  def self.recent_nodes
    Snapshot.last.nodes
  end

end