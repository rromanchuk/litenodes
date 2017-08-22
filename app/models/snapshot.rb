class Snapshot < ApplicationRecord
  has_many :nodes_snapshots
  has_many :nodes, through: :node_snapshots

end