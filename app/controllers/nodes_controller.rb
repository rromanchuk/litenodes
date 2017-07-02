class NodesController < ApplicationController
  def show
  end

  def index
    @nodes = Node.all
    respond_to do |format|
      format.html  # index.html.erb
      format.json  #{ render :json => @nodes }
    end
  end
end
