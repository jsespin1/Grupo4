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




end