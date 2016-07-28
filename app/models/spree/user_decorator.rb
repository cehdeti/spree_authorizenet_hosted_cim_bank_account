Spree.user_class.class_eval do
  has_many :bank_accounts, class_name: "Spree::BankAccount", foreign_key: :user_id

  def default_bank_account
    bank_accounts.default.first
  end

  def default_payment_source
    default_credit_card || default_bank_account
  end

  def payment_sources
    [:credit_cards, :bank_accounts].map do |association|
      send(association).with_payment_profile.to_a
    end.sum
  end
end if Spree.user_class
