Spree::CreditCard.class_eval do
  def ensure_one_default
    if self.user_id && self.default
      [self.class, ::Spree::BankAccount].each do |klass|
        klass.where(default: true, user_id: self.user_id).where.not(id: self.id)
          .update_all(default: false)
      end
    end
  end
end
