class NodesIndex < Chewy::Index
  define_type Node do
    field :ip
    field :user_agent
    field :org
  end
end