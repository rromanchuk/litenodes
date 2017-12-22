class Node < ApplicationRecord


  has_many :alerts, dependent: :destroy
  has_many :node_snapshots, dependent: :destroy
  has_many :snapshots, through: :node_snapshots
  has_many :pings, dependent: :destroy

  before_create :determine_ip_version, :determine_friendly_country_name

  update_index('nodes#node') { self }

  PINGS_LIMIT = 50
  SERVICES_SCORE = {13 => 1, 1 => 0}

  def self.last_export
    Redis.current.get('last_export')
  end

  def self.height
    Redis.current.get('height').to_i || 0
  end

  def self.search(q)
    NodesIndex::Node.query(multi_match: {query: q, fields: ['user_agent', 'org', 'country_friendly_name', 'address', 'org']}).load
  end

  def self.ip_versions
    Node.group(:ip_version).count
  end

  def self.add_node(address, port)
    Redis.current.zadd("check", Time.now.to_i.to_s, [address, port, "1"].to_json)
  end

  def rtt_latency_array
    Redis.current.lrange("rtt:#{ip.to_s}-#{port}", 0, 10).map(&:to_i)
  end

  def average_latency
     rtt_latency_array.reduce(:+).to_f / rtt_latency_array.size
  end

  def status
    Snapshot.last.nodes.find_by(address: address, port: port).nil? ? "DOWN" : "UP"
  end

  def determine_friendly_country_name
    self.country_friendly_name = Country[country]&.translated_names&.first
  end

  def clean_agent
    user_agent.gsub("/", "")
  end

  def determine_ip_version
    ip_version_str = nil
    if ip.nil?
      ip_version_str = :onion
    elsif ip.ipv4?
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

  def trim_pings
    fresh_ids = pings.limit(PINGS_LIMIT).pluck(:id)
    pings.where.not(id: fresh_ids).destroy_all
  end

  # scoring
  def pix
    # PIX = ((VI + SI + HI + AI + PI + DLI + DUI + WLI + WUI + MLI + MUI + NSI + NI + BI) / 14.0) x 10.0
  end

  def pi
    port == "9333" ? 1.0 : 0.0
  end

  def hi
    height / Snapshot.height
  end

  def si
    services == 13 ? 1 : 0
  end

end
