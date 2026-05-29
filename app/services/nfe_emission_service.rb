class NfeEmissionService
  class EmissionError < StandardError; end

  def self.call(order)
    new(order).call
  end

  def initialize(order)
    @order  = order
    @config = FiscalConfiguration.current
    @client = FocusNfeClient.new
  end

  def call
    validate!

    ref     = generate_ref
    payload = NfePayloadBuilder.call(@order)
    doc     = create_pending_document(ref, payload)

    Rails.logger.info("[NfeEmissionService] payload: #{payload.to_json}")
    response = @client.emitir_nfe(ref: ref, payload: payload)
    update_document(doc, response)
    increment_numero_nfe!

    doc
  rescue FocusNfeClient::ApiError => e
    handle_api_error(e)
  end

  private

  def validate!
    raise EmissionError, "Configuração fiscal não encontrada." unless @config
    raise EmissionError, "Token da Focus NF-e não configurado." if @config.focus_nfe_token.blank?
    raise EmissionError, "Pedido já possui nota fiscal emitida." if @order.fiscal_document&.authorized?
    raise EmissionError, "Pedido sem itens." if @order.order_items.empty?

    @order.order_items.includes(:product).each do |item|
      if item.product.ncm_efetivo.blank?
        raise EmissionError, "Produto '#{item.product.name}' sem NCM. Configure o NCM no produto ou na categoria."
      end
    end
  end

  def generate_ref
    "caixaflow-order-#{@order.id}-#{Time.current.to_i}"
  end

  def create_pending_document(ref, payload)
    @order.create_fiscal_document!(
      focus_ref: ref,
      serie:     @config.serie_nfe,
      numero:    @config.numero_atual_nfe,
      status:    :pending
    )
  end

  def update_document(doc, response)
    status = map_status(response["status"])
    doc.update!(
      status:           status,
      chave_acesso:     response["chave_nfe"],
      protocolo:        response["protocolo"],
      motivo_rejeicao:  response["motivo"],
      danfe_url:        status == "authorized" ? @client.danfe_url(doc.focus_ref) : nil,
      emitted_at:       status == "authorized" ? Time.current : nil
    )
  end

  def map_status(focus_status)
    case focus_status
    when "autorizado"    then "authorized"
    when "rejeitado"     then "rejected"
    when "cancelado"     then "cancelled"
    else                      "pending"
    end
  end

  def increment_numero_nfe!
    @config.increment!(:numero_atual_nfe)
  end

  def handle_api_error(error)
    body = error.body
    mensagem = body.is_a?(Hash) ? (body["mensagem"] || body.inspect) : body.to_s
    Rails.logger.error("[NfeEmissionService] API error #{error.status}: #{mensagem}")
    raise EmissionError, "Erro na API Focus NF-e (#{error.status}): #{mensagem}"
  end
end
