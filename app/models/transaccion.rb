class Transaccion < ActiveRecord::Base

	  #t.string :_id
      #t.datetime :fecha_creacion
      #t.string :cuenta_origen
      #t.string :cuenta_destino
      #t.float :monto

    def self.toObject(response)
      r = response
  	 	transaccion = Transaccion.new(_id: r['_id'].to_s, fecha_creacion: r['created_at'], cuenta_origen: r['origen'].to_s, cuenta_destino: r['destino'].to_s, 
  	 		monto: r['monto'].to_f)
    end

    def self.toObject2(response)
    	r = response[0]
	 	  transaccion = Transaccion.new(_id: r['_id'], fecha_creacion: r['created_at'], cuenta_origen: r['origen'], cuenta_destino: r['destino'], 
	 		    monto: r['monto'])
    end


end
