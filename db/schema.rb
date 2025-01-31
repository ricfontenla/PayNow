# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_18_204111) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "boleto_accounts", force: :cascade do |t|
    t.string "bank_code"
    t.string "agency_number"
    t.string "bank_account"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "payment_method_id", null: false
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_boleto_accounts_on_company_id"
    t.index ["payment_method_id"], name: "index_boleto_accounts_on_payment_method_id"
  end

  create_table "card_accounts", force: :cascade do |t|
    t.string "credit_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id", null: false
    t.integer "payment_method_id", null: false
    t.index ["company_id"], name: "index_card_accounts_on_company_id"
    t.index ["payment_method_id"], name: "index_card_accounts_on_payment_method_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "email_domain"
    t.string "cnpj"
    t.string "name"
    t.string "billing_adress"
    t.string "billing_email"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_final_customers", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "final_customer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_final_customers_on_company_id"
    t.index ["final_customer_id"], name: "index_company_final_customers_on_final_customer_id"
  end

  create_table "company_histories", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "billing_adress"
    t.string "billing_email"
    t.string "token"
    t.integer "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_histories_on_company_id"
  end

  create_table "final_customers", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_histories", force: :cascade do |t|
    t.integer "status", default: 1
    t.string "response_code", default: "01 - Pendente de cobrança"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order_id", null: false
    t.index ["order_id"], name: "index_order_histories_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "token"
    t.integer "status", default: 1
    t.decimal "original_price"
    t.decimal "final_price"
    t.integer "choosen_payment"
    t.string "adress"
    t.string "card_number"
    t.string "printed_name"
    t.string "verification_code"
    t.integer "company_id", null: false
    t.integer "final_customer_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["final_customer_id"], name: "index_orders_on_final_customer_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.decimal "billing_fee"
    t.decimal "max_fee"
    t.boolean "status", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category"
  end

  create_table "pix_accounts", force: :cascade do |t|
    t.string "pix_key"
    t.string "bank_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id", null: false
    t.integer "payment_method_id", null: false
    t.index ["company_id"], name: "index_pix_accounts_on_company_id"
    t.index ["payment_method_id"], name: "index_pix_accounts_on_payment_method_id"
  end

  create_table "product_histories", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.decimal "pix_discount"
    t.decimal "card_discount"
    t.decimal "boleto_discount"
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_histories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.decimal "pix_discount"
    t.decimal "card_discount"
    t.decimal "boleto_discount"
    t.string "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.string "token"
    t.integer "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_receipts_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0, null: false
    t.integer "company_id"
    t.boolean "status", default: true, null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boleto_accounts", "companies"
  add_foreign_key "boleto_accounts", "payment_methods"
  add_foreign_key "card_accounts", "companies"
  add_foreign_key "card_accounts", "payment_methods"
  add_foreign_key "company_final_customers", "companies"
  add_foreign_key "company_final_customers", "final_customers"
  add_foreign_key "company_histories", "companies"
  add_foreign_key "order_histories", "orders"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "final_customers"
  add_foreign_key "orders", "products"
  add_foreign_key "pix_accounts", "companies"
  add_foreign_key "pix_accounts", "payment_methods"
  add_foreign_key "product_histories", "products"
  add_foreign_key "products", "companies"
  add_foreign_key "receipts", "orders"
  add_foreign_key "users", "companies"
end
