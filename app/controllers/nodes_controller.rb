class NodesController < ApplicationController
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

  def index
    @user_agents = Node.group(:user_agent).order('count_all desc').limit(6).count
    @countries = Node.group(:country).order('count_all desc').limit(6).count
    @networks = Node.group(:org).order('count_all desc').limit(6).count
    @all_nodes = Node.count
    @nodes = Node.order('updated_at desc').page params[:page]

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


end
