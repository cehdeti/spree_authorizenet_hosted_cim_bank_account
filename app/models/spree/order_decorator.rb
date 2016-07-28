Spree::Order.class_eval do
  # Overridden from `Spree::Order`.
  #
  # Changed the name of the `existing_card` param to `existing_payment_source`
  # and parse it according to the new format.
  def update_from_params(params, permitted_params, request_env = {})
    success = false
    @updating_params = params
    run_callbacks :updating_from_params do
      # Set existing card after setting permitted parameters because
      # rails would slice parameters containg ruby objects, apparently
      existing_payment_source = @updating_params[:order] ? @updating_params[:order].delete(:existing_payment_source) : nil

      attributes = @updating_params[:order] ? @updating_params[:order].permit(permitted_params).delete_if { |_k, v| v.nil? } : {}

      if existing_payment_source.present?
        class_name, source_id = existing_payment_source.split('/')
        source = class_name.constantize.find(source_id)

        raise Core::GatewayError.new Spree.t(:invalid_credit_card) if source.user_id != user_id || source.user_id.blank?

        source.verification_value = params[:cvc_confirm] if source.is_a?(Spree::CreditCard) && params[:cvc_confirm].present?

        attributes[:payments_attributes].first[:source] = source
        attributes[:payments_attributes].first[:payment_method_id] = source.payment_method_id
        attributes[:payments_attributes].first.delete :source_attributes
      end

      if attributes[:payments_attributes]
        attributes[:payments_attributes].first[:request_env] = request_env
      end

      success = update_attributes(attributes)
      set_shipments_cost if shipments.any?
    end

    @updating_params = nil
    success
  end

  # Overridden from `Spree::Order`.
  #
  # Changed the name of the `existing_card` param to `existing_payment_source`.
  def update_params_payment_source
    if @updating_params[:payment_source].present?
      source_params = @updating_params.
                      delete(:payment_source)[@updating_params[:order][:payments_attributes].
                                              first[:payment_method_id].to_s]

      if source_params
        @updating_params[:order][:payments_attributes].first[:source_attributes] = source_params
      end
    end

    if @updating_params[:order] && (@updating_params[:order][:payments_attributes] ||
                                    @updating_params[:order][:existing_payment_source])
      @updating_params[:order][:payments_attributes] ||= [{}]
      @updating_params[:order][:payments_attributes].first[:amount] = order_total_after_store_credit
    end
  end
end
