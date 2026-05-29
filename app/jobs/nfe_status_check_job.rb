class NfeStatusCheckJob < ApplicationJob
  queue_as :low

  # Consulta o status de notas pendentes na Focus NF-e.
  # Disparado por polling no front ou via sidekiq-cron a cada 2 minutos.
  def perform(fiscal_document_id)
    doc    = FiscalDocument.find(fiscal_document_id)
    return unless doc.pending?

    client   = FocusNfeClient.new
    response = client.consultar_nfe(doc.focus_ref)
    status   = map_status(response["status"])

    doc.update!(
      status:          status,
      chave_acesso:    response["chave_nfe"] || doc.chave_acesso,
      protocolo:       response["protocolo"] || doc.protocolo,
      motivo_rejeicao: response["motivo"],
      danfe_url:       status == "authorized" ? client.danfe_url(doc.focus_ref) : doc.danfe_url,
      emitted_at:      status == "authorized" && doc.emitted_at.nil? ? Time.current : doc.emitted_at
    )
  rescue FocusNfeClient::ApiError => e
    Rails.logger.error("[NfeStatusCheckJob] doc=#{fiscal_document_id} error=#{e.status} #{e.body}")
  end

  private

  def map_status(focus_status)
    case focus_status
    when "autorizado" then "authorized"
    when "rejeitado"  then "rejected"
    when "cancelado"  then "cancelled"
    else                   "pending"
    end
  end
end
