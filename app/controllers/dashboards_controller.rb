class DashboardsController < ApplicationController
  def financiero
  end

  def logistico
  	@almacenes = Request.getAlmacenesAll
  end

  
end
