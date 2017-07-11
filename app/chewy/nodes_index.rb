class NodesIndex < Chewy::Index
  define_type Node do
    field :address
    field :user_agent
    field :org
  end
end