class Node < ApplicationRecord
  before_create :determine_ip_version

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

  def rtt_latency_array
    Redis.current.lrange("rtt:#{ip.to_s}-#{port}", 0, 10)
  end

  def status
    key = "node:#{ip.to_s}-{port}-{from_services}"

  end

  def determine_ip_version
    ip_version_str = nil
    if ip.ipv4?
      ip_version_str = :ipv4
    elsif ip.ipv6?
      ip_version_str = :ipv6
    end

    self.ip_version = ip_version_str
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
