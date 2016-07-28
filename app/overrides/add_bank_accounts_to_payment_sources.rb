Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'add_bank_accounts_to_payment_sources',
  replace_contents: "[data-hook='existing_cards']",
  text: <<-TEXT
    <%= render partial: 'spree/checkout/payment/payment_sources', locals: {
      payment_sources: @payment_sources
    } %>
  TEXT
)
