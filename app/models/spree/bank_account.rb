module Spree
  class BankAccount < Spree::Base
    belongs_to :payment_method
    belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
    has_many :payments, as: :source

    after_save :ensure_one_default

    validates :account_number_last_digits, presence: true

    scope :with_payment_profile, -> { where('gateway_customer_profile_id IS NOT NULL') }
    scope :default, -> { where(default: true) }

    attr_accessor :imported

    def actions
      %w{capture void credit}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      !payment.failed? && !payment.void?
    end

    # Indicates whether its possible to credit the payment.  Note that most gateways require that the
    # payment be settled first which generally happens within 12-24 hours of the transaction.
    def can_credit?(payment)
      payment.completed? && payment.credit_allowed > 0
    end

    def has_payment_profile?
      gateway_customer_profile_id.present? || gateway_payment_profile_id.present?
    end

    # ActiveMerchant needs first_name/last_name because we pass it a Spree::CreditCard and it calls those methods on it.
    # Looking at the ActiveMerchant source code we should probably be calling #to_active_merchant before passing
    # the object to ActiveMerchant but this should do for now.
    def first_name
      name.to_s.split(/[[:space:]]/, 2)[0]
    end

    def last_name
      name.to_s.split(/[[:space:]]/, 2)[1]
    end

    private

    def ensure_one_default
      if self.user_id && self.default
        [self.class, ::Spree::CreditCard].each do |klass|
          klass.where(default: true, user_id: self.user_id).where.not(id: self.id)
            .update_all(default: false)
        end
      end
    end
  end
end
