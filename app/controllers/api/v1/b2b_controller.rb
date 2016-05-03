class Api::V1::B2bController < ApplicationController

	respond_to :json, :html

	def getStock
		respond_to do |format|
			id = params[:_id].to_i
			if params[:_id]
				respuesta = Controlador.getStock(params[:_id].to_i)
				total = respuesta.to_i
				if total > 0
					format.json {render json: {stock: total, sku: id},status:200}
				else
					format.json {render json: {description: 'No hay productos de ese SKU'},status:404}
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end

	end

	def analizarOC
		respond_to do |format|
			if params[:_idorden]
				id = params[:_idorden]
				@oc = Request.getOC(id)[0]
				#luego se debe revisar el stock, sumando todos los almacenes
				sku = @oc['sku'].to_s
				cantidadOrden=@oc['cantidad'].to_i

				if cantidadOrden<=Almacen.getSkusTotal(sku)
					format.json{render json: {aceptado: true, idoc: id.to_s}, status:200}
				else
					format.json{render json: {aceptado: false, idoc: id.to_s}, status: 200}
				end
			else
				format.json {render json: {description: 'Missing parameters'},status:400}
			end
		end
	
	end




end