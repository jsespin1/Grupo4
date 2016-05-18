class AddOrdenToFactura < ActiveRecord::Migration
  def change
    add_reference :facturas, :orden, index: true, foreign_key: true
  end
end
