module NodesHelper
    NODE_NONE = 0
    NODE_NETWORK = 1 << 0
    NODE_GETUTXO = 1 << 1
    NODE_BLOOM = 1 << 2
    NODE_WITNESS = 1 << 3
    NODE_XTHIN = 1 << 4

  def services_string(mask)
    services = []
    services <<  "NODE_NETWORK" if mask & NODE_NETWORK > 0
    services <<  "NODE_GETUTXO" if mask & NODE_GETUTXO > 0
    services <<  "NODE_BLOOM" if mask & NODE_BLOOM > 0
    services <<  "NODE_WITNESS" if mask & NODE_WITNESS > 0
    services <<  "NODE_XTHIN" if mask & NODE_XTHIN > 0
    services.join(', ')
  end

  def services_array(mask)
    services = []
    services <<  "NODE_NETWORK" if mask & NODE_NETWORK > 0
    services <<  "NODE_GETUTXO" if mask & NODE_GETUTXO > 0
    services <<  "NODE_BLOOM" if mask & NODE_BLOOM > 0
    services <<  "NODE_WITNESS" if mask & NODE_WITNESS > 0
    services <<  "NODE_XTHIN" if mask & NODE_XTHIN > 0
    services
  end
end
