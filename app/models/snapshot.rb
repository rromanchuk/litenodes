class Snapshot < ApplicationRecord
  has_many :nodes_snapshots
  has_many :nodes, through: :nodes_snapshots

end