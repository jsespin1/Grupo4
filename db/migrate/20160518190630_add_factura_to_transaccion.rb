class AddFacturaToTransaccion < ActiveRecord::Migration
  def change
    add_reference :transaccions, :factura, index: true, foreign_key: true
  end
end
