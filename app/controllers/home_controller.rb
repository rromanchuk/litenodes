class HomeController < ApplicationController
  def index
    @recent_nodes = Snapshot.recent_nodes
    @host_address = request.remote_ip
    @countries = @recent_nodes.group(:country).order('count_all desc').limit(10).count
    @all_nodes = @recent_nodes.count
  end
end