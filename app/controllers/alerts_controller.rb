class AlertsController < ApplicationController
  def create
    node = Node.find(params[:node_id])
    Alert.create!(node: node, email: params[:email])
  end
end