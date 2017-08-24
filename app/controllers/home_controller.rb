class HomeController < ApplicationController
  def index
    @nodes = Snapshot.recent_nodes
    @host_address = request.remote_ip
    @countries = @nodes.group(:country).order('count_all desc').limit(10).count
    @all_nodes = @nodes.count
  end
end