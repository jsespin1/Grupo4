class Transaccion < ActiveRecord::Base

	  #t.string :_id
      #t.datetime :fecha_creacion
      #t.string :cuenta_origen
      #t.string :cuenta_destino
      #t.float :monto
    validates :_id, :presence => true, :uniqueness => true
    belongs_to :factura

    def self.toObject(response)
      transaccion = nil
      r = response
      if r.to_s.include? '_id'
        transaccion = Transaccion.new(_id: r['_id'].to_s, fecha_creacion: r['created_at'], cuenta_origen: r['origen'].to_s, cuenta_destino: r['destino'].to_s, 
        monto: r['monto'].to_f)
      end
  	 	transaccion
    end

    def self.toObject2(response)
      transaccion = nil
    	r = response[0]
	 	  if r.to_s.include? '_id'
        transaccion = Transaccion.new(_id: r['_id'].to_s, fecha_creacion: r['created_at'], cuenta_origen: r['origen'].to_s, cuenta_destino: r['destino'].to_s, 
        monto: r['monto'].to_f)
      end
      transaccion
    end


end
