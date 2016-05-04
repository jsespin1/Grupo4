class AddParamsToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :_id, :string
    add_column :facturas, :fecha_creacion, :datetime
    add_column :facturas, :proveedor, :string
    add_column :facturas, :cliente, :string
    add_column :facturas, :valor_bruto, :integer
    add_column :facturas, :iva, :integer
    add_column :facturas, :valor_total, :integer
    add_column :facturas, :estado_pago, :string
    add_column :facturas, :fecha_pago, :datetime
    add_column :facturas, :id_oc, :string
    add_column :facturas, :motivo_rechazo, :string
    add_column :facturas, :motivo_anulacion, :string
  end
end
