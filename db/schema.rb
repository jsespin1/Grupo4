# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160505131937) do

  create_table "almacens", force: :cascade do |t|
    t.string   "_id"
    t.integer  "grupo"
    t.boolean  "pulmon"
    t.boolean  "despacho"
    t.boolean  "recepcion"
    t.integer  "totalSpace"
    t.integer  "usedSpace"
    t.integer  "v"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bodegas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compras", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "controladors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facturas", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "_id"
    t.datetime "fecha_creacion"
    t.string   "proveedor"
    t.string   "cliente"
    t.integer  "valor_bruto"
    t.integer  "iva"
    t.integer  "valor_total"
    t.string   "estado_pago"
    t.datetime "fecha_pago"
    t.string   "id_oc"
    t.string   "motivo_rechazo"
    t.string   "motivo_anulacion"
  end

  create_table "ftps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ordens", force: :cascade do |t|
    t.string   "_id"
    t.datetime "fecha_creacion"
    t.string   "canal"
    t.string   "proveedor"
    t.string   "cliente"
    t.string   "sku"
    t.integer  "cantidad"
    t.integer  "cantidad_despachada"
    t.integer  "precio_unitario"
    t.datetime "fecha_entrega"
    t.datetime "fecha_despacho"
    t.string   "estado"
    t.string   "motivo_rechazo"
    t.string   "motivo_anulacion"
    t.string   "notas"
    t.string   "id_factura"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "productos", force: :cascade do |t|
    t.string   "_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cantidad"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saldos", force: :cascade do |t|
    t.string   "_id"
    t.string   "cuenta"
    t.float    "monto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skus", force: :cascade do |t|
    t.string   "_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cantidad"
  end

  create_table "transaccions", force: :cascade do |t|
    t.string   "_id"
    t.datetime "fecha_creacion"
    t.string   "cuenta_origen"
    t.string   "cuenta_destino"
    t.float    "monto"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
