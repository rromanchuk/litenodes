json.(node, :id, :port, :version, :user_agent, :services, :height, :timestamp, :hostname, :created_at, :updated_at)
json.ip node.address
json.services services_array(node.services)