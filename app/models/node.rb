class Node < ApplicationRecord

  update_index('nodes#node') { self }

  def self.height
    Redis.current.get('height') || 0
  end
end
