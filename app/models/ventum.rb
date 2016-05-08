class Ventum < ActiveRecord::Base

	def vender_materia_prima(sku,id_grupo,cantidad_materia_prima)
		id_pulmon = Almacen.getIdPulmon 
		id_despacho = Almacen.getIdDespacho
		cantidad_sku_almacen_despacho = Request.getStock(id_despacho,sku)
		cantidad_sku_total = Request.getSkusTotal(sku)
		#cantidad_sku_total_pulmon = Request.getSkusTotalPulmon(sku) --> hay que hacer este método.


		if cantidad_sku >= cantidad_materia_prima
			#vender.
		else if cantidad_sku_almacen_despacho >= cantidad_materia_prima
			Controlador.moverBodegaDespacho(sku, cantidad, oc)


			end
		end

		end
		
		if sku == 44
		end	

	end

	def vender_producto_procesado()

end


self.getStock(almacenID, skuId)