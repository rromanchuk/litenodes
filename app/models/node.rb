class Node < ApplicationRecord

  update_index('nodes#node') { self }

  def self.height
    Redis.current.get('height').to_i || 0
  end
end
