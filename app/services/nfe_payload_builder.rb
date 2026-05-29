class NfePayloadBuilder
  # Constrói o payload JSON para a API Focus NF-e (modelo 55, Simples Nacional CSOSN 400)
  def self.call(order)
    new(order).build
  end

  def initialize(order)
    @order  = order
    @config = FiscalConfiguration.current
  end

  def build
    {
      natureza_operacao:          "Venda de mercadoria",
      forma_pagamento:            0,
      modelo:                     55,
      serie:                      @config.serie_nfe,
      numero:                     @config.numero_atual_nfe,
      data_emissao:               Time.current.strftime("%Y-%m-%dT%H:%M:%S-03:00"),
      data_entrada_saida:         Time.current.strftime("%Y-%m-%dT%H:%M:%S-03:00"),
      tipo_documento:             1,
      local_destino:              1,
      finalidade_emissao:         1,
      consumidor_final:           1,
      presenca_comprador:         1,
      emitente:                   build_emitente,
      destinatario:               build_destinatario,
      items:                      build_items,
      pagamentos:                 build_pagamentos,
      informacoes_adicionais_contribuinte: "Documento emitido por sistema de gestão CaixaFlow."
    }
  end

  private

  def build_emitente
    {
      cnpj:                       @config.cnpj.gsub(/\D/, ""),
      razao_social:               @config.razao_social,
      nome_fantasia:              @config.nome_fantasia,
      logradouro:                 @config.logradouro,
      numero:                     @config.numero,
      complemento:                @config.complemento,
      bairro:                     @config.bairro,
      municipio:                  @config.municipio,
      uf:                         @config.uf,
      cep:                        @config.cep.gsub(/\D/, ""),
      codigo_municipio:           @config.codigo_municipio,
      telefone:                   "",
      regime_tributario:          @config.regime_tributario_before_type_cast,
      inscricao_estadual:         @config.ie,
      inscricao_municipal:        @config.im
    }.compact
  end

  def build_destinatario
    customer = @order.customer
    return { nome: "CONSUMIDOR NAO IDENTIFICADO", indicador_inscricao_estadual: 9 } if customer.nil?

    doc = customer.cpf_cnpj&.gsub(/\D/, "")
    dest = { nome: customer.name, indicador_inscricao_estadual: 9 }
    dest[:email] = customer.email if customer.email.present?

    if doc.present?
      doc.length == 11 ? dest[:cpf] = doc : dest[:cnpj] = doc
    end

    dest
  end

  def build_items
    @order.order_items.includes(:product).map.with_index(1) do |item, idx|
      product = item.product
      ncm     = product.ncm_efetivo&.gsub(/\D/, "") || "00000000"
      cfop    = @config.cfop_padrao

      {
        numero_item:                    idx,
        codigo_produto:                 product.id.to_s,
        descricao:                      product.name,
        codigo_ncm:                     ncm,
        cfop:                           cfop,
        unidade_comercial:              product.unidade || "UN",
        quantidade_comercial:           item.quantity,
        valor_unitario_comercial:       item.unit_price.to_f,
        valor_bruto:                    item.subtotal.to_f,
        unidade_tributavel:             product.unidade || "UN",
        quantidade_tributavel:          item.quantity,
        valor_unitario_tributavel:      item.unit_price.to_f,
        tributos: {
          icms: build_icms_simples_nacional
        }
      }
    end
  end

  def build_icms_simples_nacional
    # CSOSN 400: tributado pelo Simples Nacional sem permissão de crédito
    # Não há destaque de ICMS na nota — o mais comum para pequeno varejo
    {
      situacao_tributaria: "400",
      origem:              0
    }
  end

  def build_pagamentos
    [
      {
        forma_pagamento: payment_code,
        valor:           @order.total.to_f
      }
    ]
  end

  def payment_code
    {
      "cash"        => "01",
      "pix"         => "17",
      "debit_card"  => "04",
      "credit_card" => "03"
    }.fetch(@order.payment_method, "99")
  end
end
