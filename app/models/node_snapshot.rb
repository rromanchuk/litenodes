class NodeSnapshot < ApplicationRecord
  belongs_to :node
  belongs_to :snapshot

end