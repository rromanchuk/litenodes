NODE_NONE = 0
NODE_NETWORK = 1 << 0
NODE_GETUTXO = 1 << 1
NODE_BLOOM = 1 << 2
NODE_WITNESS = 1 << 3
NODE_XTHIN = 1 << 4

namespace :litenodes do
  desc "TODO"
  task process_nodes: :environment do
    Chewy.strategy(:atomic)
    path = File.expand_path("../test.json", __FILE__)
    file = File.read(path)
    nodes_arr = JSON.parse(file)
    snapshot = Snapshot.create!(crawled_at: Time.current, num_nodes: nodes_arr.length, height: 20000)

    node_objects = process_node_array(nodes_arr)
    snapshot.nodes = node_objects
  end

  task process_last: :environment do
    Chewy.strategy(:atomic)
    file_path = Dir.glob("/home/ubuntu/bitnodes/data/export/**/*.*").sort_by { |file_name| File.stat(file_name).mtime }
    file = File.read(file_path)
    nodes_arr = JSON.parse(file)
    node_objects = process_node_array(nodes_arr)
  end

  task listen_for_export: :environment do
    Chewy.strategy(:atomic)

    client = Redis.new url: ENV["REDIS_URL"]
    client.subscribe("export") do |on|
      on.message do |channel, msg|
        Rails.logger.info("[listen_for_export] Broadcast on channel #{channel}: #{msg}")
        file = File.read("/home/ubuntu/bitnodes/data/export/fbc0b6db/#{msg}.json")
        nodes_arr = JSON.parse(file)
        Rails.logger.info("[listen_for_export] Found #{nodes_arr.length} nodes to update")
        snapshot = Snapshot.create!(crawled_at: Time.at(msg.to_i), num_nodes: nodes_arr.length, height: Node.height)
        node_objects = process_node_array(nodes_arr)
        Rails.logger.info "Adding #{node_objects.length} node objects to snapshot #{snapshot.inspect}"
        snapshot.nodes = node_objects
      end
    end
  end

  def process_node_array(nodes)

    node_objects = []
    nodes.each do |a|
      Rails.logger.info "[process_node_array] address: #{a[0]}, port: #{a[1]}, version: #{a[2]}, user_agent: #{a[3]}, timestamp: #{a[4]}, services: #{a[5]}, height: #{a[6]}, hostname: #{a[7]}, city: #{a[8]}, country: #{a[9]}, latitude: #{a[10]}, longitude: #{a[11]}, timezone: #{a[12]}, asn: #{a[13]}, org: #{a[14]}"
      timestamp = Time.at(a[4])

      begin
        inet = IPAddr.new a[0]
      rescue IPAddr::InvalidAddressError => e
        inet = nil
      end

      if node = Node.find_by(address: a[0], port: a[1])
        node.update_attributes!(ip: inet, address: a[0], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14] )
        node_objects << node
      else
        case a[3]
        when /Feathercoin/
          Rails.logger.info "Skipping for user_agent #{a[3]}"
          next
        when /Digitalcoin/
          Rails.logger.info "Skipping for user_agent #{a[3]}"
          next
        when /Reddcoin/
          Rails.logger.info "Skipping for user_agent #{a[3]}"
          next
        when /Worldcoin/|/Awcoin/|/Node/|/DrVenkman/
           next
        else
          node = Node.create!(ip: inet, address: a[0], port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14])
          node_objects << node
        end
      end
    end
    node_objects
  end

end
