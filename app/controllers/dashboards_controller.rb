class DashboardsController < ApplicationController
  def financiero
  end

  def logistico
  	@almacenes = Request.getAlmacenesAll
  end

  def show_transacciones
  	@inicio =  params[:fecha_inicial]
  	@final = params[:fecha_final]
  end

end
