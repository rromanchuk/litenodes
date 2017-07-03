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

      Node.find_or_initialize_by(ip: a[0]) do |node|
        node.update_attributes(port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11] )
      end

      # if node = Node.find(a[0])
      #   node.update_attributes(port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11] )
      # else
      #   node = Node.new(address: a[0], port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11] )
      #   node.save
      # end


      sleep 1
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
          # address, port, version, user_agent, timestamp, services, height, hostname, city, country, latitude, longitude, timezone, asn, org
          Rails.logger.info "address: #{a[0]}, port: #{a[1]}, version: #{a[2]}, user_agent: #{a[3]}, timestamp: #{a[4]}, services: #{a[5]}, height: #{a[6]}, hostname: #{a[7]}, city: #{a[8]}, country: #{a[9]}, latitude: #{a[10]}, longitude: #{a[11]}, timezone: #{a[12]}, asn: #{a[12]}, org: #{a[13]}"
          timestamp = Time.at(a[4])

          Node.find_or_initialize_by(ip: a[0]) do |node|
            node.update_attributes(port: a[1], version: a[2], user_agent: a[3], timestamp: timestamp, services: a[5], height: a[6], hostname: a[7], city: a[8], country: a[9], latitude: a[10], longitude: a[11] )
          end

        end
      end
    end
  end

end
