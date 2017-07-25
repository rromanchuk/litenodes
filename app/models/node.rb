class Node < ApplicationRecord

  update_index('nodes#node') { self }

  def self.height
    Redis.current.get('height').to_i || 0
  end

  def self.search(q)
    NodesIndex.query(nodes_query(q)).load
  end

  def self.ipv4_nodes
    Node.group('family').select('family(ip), COUNT(*)')
  end

  def self.ipv6_nodes
    Node.group('family').select('family(ip), COUNT(*)')
  end

  def self.nodes_query(q)
    {
      multi_match: { query: q, fields: ['user_agent', 'address'] }
    }
  end

  def to_geojson
    [longitude.to_f, latitude.to_f]
  end

  def self.to_geojson(nodes)
    {type: "FeatureCollection",
      features: [
        type: "Feature",
        geometry: {
          type: "MultiPoint",
          coordinates: nodes.map(&:to_geojson)
        }
      ]
    }
  end

end
