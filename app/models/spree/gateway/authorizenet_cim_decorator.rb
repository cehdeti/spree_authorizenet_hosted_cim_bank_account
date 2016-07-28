Spree::Gateway::AuthorizeNetCim.class_eval do
  def create_bank_account_from_customer_payment_profile(profile, customer_profile_id, user)
    address = create_address_from_customer_payment_profile(profile)

    Spree::BankAccount.create!(
      account_type: profile['payment']['bank_account']['account_type'],
      account_number_last_digits: profile['payment']['bank_account']['account_number'].last(4),
      routing_number_last_digits: profile['payment']['bank_account']['routing_number'].last(4),
      bank_name: profile['payment']['bank_account']['bank_name'],
      address_id: address.id,
      gateway_customer_profile_id: customer_profile_id,
      gateway_payment_profile_id: profile['customer_payment_profile_id'],
      name: profile['payment']['bank_account']['name_on_account'] || "#{profile['bill_to']['first_name']} #{profile['bill_to']['last_name']}",
      user_id: user.id,
      payment_method_id: id
    )
  end
end
