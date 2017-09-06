class NodesIndex < Chewy::Index
  define_type Node do
    field :address
    field :user_agent
    field :org
    field :country_friendly_name
    field :timestamp, 'datetime'
  end
end