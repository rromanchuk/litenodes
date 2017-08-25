class NodesController < ApplicationController
  def join
    Node.add_node(params[:host], params[:port])
  end

  def show
    @node = Node.find params[:id]
    respond_to do |format|
      format.html  # index.html.erb
      format.json  #{ render :json => @nodes }
    end
  end

  def by_host_and_port
    @node = Node.find_by(ip: params[:host], port: params[:port])
    respond_to do |format|
      format.html  # index.html.erb
      format.json  #{ render :json => @nodes }
    end
  end

  def show
    @node = Node.find params[:id]
    respond_to do |format|
      format.html  # index.html.erb
      format.json  #{ render :json => @nodes }
    end
  end

  def latency
    node = Node.find params[:id]
    @latency_arr = node.rtt_latency_array
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @latency_arr }
    end
  end

  def index
    @last_snapshot = Snapshot.last
    @recent_nodes = @last_snapshot.nodes
    @user_agents = @recent_nodes.group(:user_agent).order('count_all desc').limit(6).count
    @countries = @recent_nodes.group(:country).order('count_all desc').limit(6).count
    @networks = @recent_nodes.group(:org).order('count_all desc').limit(6).count
    @all_nodes = @recent_nodes.count
    @ip_version_types = @recent_nodes.group(:ip_version).count
    @nodes = @recent_nodes.order('timestamp desc').page params[:page]

    respond_to do |format|
      format.html  # index.html.erb
      format.json  #{ render :json => @nodes }
    end
  end

  def user_agents
    @user_agents = Node.group(:user_agent).order('count_all desc').count

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @user_agents }
    end
  end

  def countries
    @countries = Node.group(:country).order('count_all desc').count
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @countries }
    end
  end

  def heatmap
    @coords = Snapshot.recent_nodes.map(&:to_geojson)
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @coords }
    end
  end


  def coordinates
    @nodes = Snapshot.recent_nodes
    @nodes = Node.to_geojson(@nodes)

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @nodes }
    end
  end


end
