class FiscalDocumentsController < ApplicationController
  before_action :set_order

  def show
    @fiscal_document = @order.fiscal_document
    redirect_to @order, alert: "Nenhuma nota fiscal para este pedido." unless @fiscal_document
  end

  def create
    if @order.fiscal_document&.authorized?
      redirect_to order_path(@order), alert: "Este pedido já possui nota fiscal autorizada."
      return
    end

    begin
      doc = NfeEmissionService.call(@order)
      if doc.authorized?
        redirect_to order_fiscal_document_path(@order), notice: "NF-e emitida com sucesso!"
      else
        redirect_to order_fiscal_document_path(@order), alert: "NF-e enviada, aguardando autorização da SEFAZ."
      end
    rescue NfeEmissionService::EmissionError => e
      redirect_to order_path(@order), alert: "Erro ao emitir NF-e: #{e.message}"
    end
  end

  def check_status
    doc = @order.fiscal_document
    NfeStatusCheckJob.perform_now(doc.id)
    doc.reload
    redirect_to order_fiscal_document_path(@order),
      notice: "Status atualizado: #{status_label(doc.status)}"
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def status_label(status)
    { "pending" => "Pendente", "authorized" => "Autorizada", "rejected" => "Rejeitada", "cancelled" => "Cancelada" }.fetch(status, status)
  end
end
