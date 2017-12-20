NODE_NONE = 0
NODE_NETWORK = 1 << 0
NODE_GETUTXO = 1 << 1
NODE_BLOOM = 1 << 2
NODE_WITNESS = 1 << 3
NODE_XTHIN = 1 << 4

namespace :litenodes do
  task process_all: :environment do
    Dir.glob("/home/ubuntu/bitnodes/data/export/fbc0b6db/*.json").sort_by { |file_path| File.stat(file_path).mtime }.each do |file_path|
      Chewy.strategy(:atomic)
      Rails.logger.info "Processing #{file_path}"
      msg = file_name.split(".")[0]
      file = File.read(file_path)
      nodes_arr = JSON.parse(file)
      snapshot = Snapshot.find_or_create_by!(crawled_at: Time.at(msg.to_i), num_nodes: nodes_arr.length)
      node_objects = process_node_array(nodes_arr)
      Rails.logger.info "Adding #{node_objects.length} node objects to snapshot #{snapshot.inspect}"
      snapshot.nodes = node_objects
      File.delete(file_path)
    end
  end


  task process_pings: :environment do
    Chewy.strategy(:atomic)
    client = Redis.new url: ENV["REDIS_URL"]
    client.scan_each(match: 'ping:*').each do |key|
      next if key.include? "ping:cidr"
      address, port = key.gsub('ping:', '').split("-")
      port, nonce = port.split(":")

      puts "address: #{address}, port: #{port}, nonce: #{nonce}"
      node = Node.where(address: address, port: port).first
      next if node.nil?
      puts "node: #{node.inspect}"
      timestamps = client.lrange key, 0, 1
      if timestamps.length > 1
        rtt = timestamps[1].to_i - timestamps[0].to_i
        Rails.logger.info "address: #{address}:#{port}, rtt: #{rtt}, timestamps: #{timestamps}"
        ping = Ping.create!(node: node, rtt: rtt, created_at: Time.at(timestamps[0].to_i), nonce: nonce)
      end

    end
  end


  desc "Listen for redis pub/sub channel when a new crawl json dump is complete and ready for import."
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
      #Rails.logger.info "[process_node_array] address: #{a[0]}, port: #{a[1]}, version: #{a[2]}, user_agent: #{a[3]}, timestamp: #{a[4]}, services: #{a[5]}, height: #{a[6]}, hostname: #{a[7]}, city: #{a[8]}, country: #{a[9]}, latitude: #{a[10]}, longitude: #{a[11]}, timezone: #{a[12]}, asn: #{a[13]}, org: #{a[14]}"
      timestamp = Time.at(a[4])

      begin
        inet = IPAddr.new a[0]
      rescue IPAddr::InvalidAddressError => e
        inet = nil
      end

      if node = Node.find_by(address: a[0], port: a[1])
        node.update_attributes!(ip: inet, address: a[0], version: a[2], user_agent: a[3], services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14] )
        node.timestamp = node.timestamp < timestamp ? timestamp : node.timestamp
        node.save!
        node_objects << node
      else
        case a[3]
        when /Feathercoin/
          next
        when /Digitalcoin/
          next
        when /Reddcoin/
          next
        when /Worldcoin/,/Awcoin/,/Node/,/DrVenkman/
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
