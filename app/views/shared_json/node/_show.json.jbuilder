json.(node, :id, :port, :version, :user_agent, :services, :height, :timestamp, :hostname, :created_at, :updated_at)
json.ip node.ip.to_s
json.services services_array(node.services)