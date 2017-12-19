class Ping < ApplicationRecord
  belongs_to :node

  after_create_commit :trim_pings


  def trim_pings
    node.trim_pings
  end
end