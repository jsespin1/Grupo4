class Sku < ActiveRecord::Base

	belongs_to :almacen

	def self.getSkus(skus)
		arreglo = []
		linea = skus.to_s
		#linea = linea.tr('[', ']', '{', '}', '')
		linea = linea.tr('[','')
		linea = linea.tr(']','')
		linea = linea.tr('{','')
		linea = linea.tr('}','')
		info = linea.split(',')
		puts "Todo -> "+ info.inspect
		id = ""
		cantidad = ""
		par = true
		info.each do |i1|
			i1 = i1.tr('','')
			i1 = i1.split('=>')
			if par == true
				id = i1[1].tr('\"','')
				puts "ID -> " + id.to_s
				par = false
			else
				cantidad = i1[1].tr('\"','')
				puts "Cantidad -> " + cantidad.to_s
				sku = Sku.new(_id: id, cantidad: cantidad)
				arreglo.push(sku)
				par = true
			end
		end
		arreglo
	end

end
