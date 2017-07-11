NODE_NONE = 0
NODE_NETWORK = 1 << 0
NODE_GETUTXO = 1 << 1
NODE_BLOOM = 1 << 2
NODE_WITNESS = 1 << 3
NODE_XTHIN = 1 << 4

namespace :litenodes do
  desc "TODO"
  task process_nodes: :environment do
    puts __FILE__
    path = File.expand_path("../test.json", __FILE__)
    puts path
    file = File.read(path)
    nodes_arr = JSON.parse(file)
    nodes_arr.each do |a|
      # address, port, version, user_agent, timestamp, services, height, hostname, city, country, latitude, longitude, timezone, asn, org
      puts a.inspect
      puts "address: #{a[0]}, port: #{a[1]}, version: #{a[2]}, user_agent: #{a[3]}, timestamp: #{a[4]}, services: #{a[5]}, height: #{a[6]}, hostname: #{a[7]}, city: #{a[8]}, country: #{a[9]}, latitude: #{a[10]}, longitude: #{a[11]}, timezone: #{a[12]}, asn: #{a[12]}, org: #{a[13]}"
      timestamp = Time.at(a[4])

      if node = Node.find_by(ip: a[0], port: a[1])
        node.update_attributes(version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14] )
      else
        Node.create!(ip: a[0], port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14])
      end

    end
  end

  task listen_for_export: :environment do


    client = Redis.current
    client.subscribe("export") do |on|
      puts on.inspect
      on.message do |channel, msg|
        Rails.logger.info("Broadcast on channel #{channel}: #{msg}")
        file = File.read("/home/ubuntu/bitnodes/data/export/#{msg}.json")
        nodes_arr = JSON.parse(file)
        nodes_arr.each do |a|
          Rails.logger.info "address: #{a[0]}, port: #{a[1]}, version: #{a[2]}, user_agent: #{a[3]}, timestamp: #{a[4]}, services: #{a[5]}, height: #{a[6]}, hostname: #{a[7]}, city: #{a[8]}, country: #{a[9]}, latitude: #{a[10]}, longitude: #{a[11]}, timezone: #{a[12]}, asn: #{a[13]}, org: #{a[14]}"
          timestamp = Time.at(a[4])
          Chewy.strategy(:atomic) do
            if node = Node.find_by(ip: a[0], port: a[1])
              node.update_attributes(version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14] )
            else
              Node.create!(ip: a[0], port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11], timezone: a[12], asn: a[13], org: a[14])
            end
          end
        end
      end
    end
  end

end
