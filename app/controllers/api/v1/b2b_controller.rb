class Api::V1::B2bController < ApplicationController

	respond_to :json, :html

	def getStock
		respond_to do |format|
			if params[:_id]
				id = params[:_id].to_i
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



























































	

	def transaccion
		respond_to do |format|
			id = params[:_id].to_i
			if params[:id_trx] && params[:id_factura]
				validacion = Controlador.validarTrx(params[:id_trx])
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




end