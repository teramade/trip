class AddLatLonToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :trips, :lat, :float
    add_column :trips, :lon, :float
  end
end
