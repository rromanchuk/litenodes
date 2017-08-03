class Node < ApplicationRecord
  before_create :determine_ip_version

  update_index('nodes#node') { self }

  def self.height
    Redis.current.get('height').to_i || 0
  end

  def self.search(q)
    NodesIndex.query(nodes_query(q)).load
  end

  def self.ip_versions
    Node.group(:ip_version).count
  end

  def self.add_node(address, port)
    Redis.current.zadd("check", Time.now.to_i.to_s, [address, port, "1"].to_json)
  end

  def self.nodes_query(q)
    {
      multi_match: { query: q, fields: ['user_agent', 'address'] }
    }
  end

  def rtt_latency_array
    Redis.current.lrange("rtt:#{ip.to_s}-#{port}", 0, 10).map(&:to_i)
  end

  def average_latency
     rtt_latency_array.reduce(:+).to_f / rtt_latency_array.size
  end

  def status
    Redis.current.hget("node:#{ip.to_s}-{port}-{from_services}", "state")
  end

  def pings
    Redis.current.lrange("ping:#{ip.to_s}-{port}", 0, -1)
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
