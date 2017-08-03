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
    @user_agents = Node.group(:user_agent).order('count_all desc').limit(6).count
    @countries = Node.group(:country).order('count_all desc').limit(6).count
    @networks = Node.group(:org).order('count_all desc').limit(6).count
    @all_nodes = Node.count
    @ip_version_types = Node.ip_versions
    @nodes = Node.order('timestamp desc').page params[:page]

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

  def coordinates
    @nodes = Node.all
    @nodes = Node.to_geojson(@nodes)

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @nodes }
    end
  end


end
