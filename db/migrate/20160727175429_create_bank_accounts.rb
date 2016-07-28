class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :spree_bank_accounts, force: :cascade do |t|
      t.string   "account_type"
      t.string   "account_number_last_digits"
      t.string   "routing_number_last_digits"
      t.string   "bank_name"
      t.integer  "address_id"
      t.string   "gateway_customer_profile_id"
      t.string   "gateway_payment_profile_id"
      t.datetime "created_at",                                  null: false
      t.datetime "updated_at",                                  null: false
      t.string   "name"
      t.integer  "user_id"
      t.integer  "payment_method_id"
      t.boolean  "default",                     default: false, null: false
    end

    add_index "spree_bank_accounts", ["address_id"], name: "index_spree_bank_accounts_on_address_id", using: :btree
    add_index "spree_bank_accounts", ["payment_method_id"], name: "index_spree_bank_accounts_on_payment_method_id", using: :btree
    add_index "spree_bank_accounts", ["user_id"], name: "index_spree_bank_accounts_on_user_id", using: :btree
  end
end
