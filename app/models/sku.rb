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
				sku = Sku.new(_id: id, cantidad: cantidad)
				arreglo.push(sku)
				par = true
			end
		end
		arreglo
	end

	def self.saveSkus(skus)
		linea = skus.to_s
		#linea = linea.tr('[', ']', '{', '}', '')
		linea = linea.tr('[','')
		linea = linea.tr(']','')
		linea = linea.tr('{','')
		linea = linea.tr('}','')
		info = linea.split(',')
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
				sku = Sku.new(_id: id, cantidad: cantidad)
				sku.save
				par = true
			end
		end
	end

end
