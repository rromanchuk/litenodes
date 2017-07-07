class Node < ApplicationRecord

  update_index('nodes#node') { self }
end
