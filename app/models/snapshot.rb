class Snapshot < ApplicationRecord
  has_many :node_snapshots
  has_many :nodes, through: :node_snapshots

  default_scope { order(created_at: :desc) }

  def self.recent_nodes
    Snapshot.last.nodes
  end

  def self.churn
    latest_snap, previous_snap = Snapshot.last(2)
    new_nodes = latest_snap.nodes - previous_snap.nodes
    lost_nodes = previous_snap.nodes - latest_snap.nodes
    [new_nodes.count, lost_nodes.count]
  end

end