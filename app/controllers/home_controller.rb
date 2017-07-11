class HomeController < ApplicationController
  def index
    @host_address = request.remote_ip
    @countries = Node.group(:country).order('count_all desc').limit(10).count
    @all_nodes = Node.count
  end
end