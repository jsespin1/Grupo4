class DashboardsController < ApplicationController
  def financiero
  	#Request.obtener_cuenta(Finanza.getCuentaPropia)
  end

  def logistico
  	@almacenes = Request.getAlmacenesAll
  end

  def show_transacciones
  	@inicio =  params[:fecha_inicial]
  	@final = params[:fecha_final]
  	@transacciones = Transaccion.where(created_at: @inicio..@final)
  end

end
