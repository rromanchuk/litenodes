class AddCountryFriendlyName < ActiveRecord::Migration[5.1]
  def change
    add_column :nodes, :country_friendly_name, :text
  end
end
