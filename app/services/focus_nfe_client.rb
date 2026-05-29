class FocusNfeClient
  BASE_URL_PRODUCTION  = "https://api.focusnfe.com.br/v2"
  BASE_URL_HOMOLOGACAO = "https://homologacao.focusnfe.com.br/v2"

  class ApiError < StandardError
    attr_reader :status, :body
    def initialize(msg, status:, body:)
      super(msg)
      @status = status
      @body   = body
    end
  end

  def initialize(token: nil, ambiente: nil)
    @token    = token    || FiscalConfiguration.current&.focus_nfe_token
    @ambiente = ambiente || (Rails.env.production? ? :production : :homologacao)
  end

  def emitir_nfe(ref:, payload:)
    post("nfe", ref: ref, payload: payload)
  end

  def consultar_nfe(ref)
    get("nfe/#{ref}")
  end

  def cancelar_nfe(ref:, justificativa:)
    delete("nfe/#{ref}", payload: { justificativa: justificativa })
  end

  def danfe_url(ref)
    "#{base_url}/nfe/#{ref}/danfe?token=#{@token}"
  end

  def xml_url(ref)
    "#{base_url}/nfe/#{ref}/xml?token=#{@token}"
  end

  private

  def base_url
    @ambiente == :production ? BASE_URL_PRODUCTION : BASE_URL_HOMOLOGACAO
  end

  def connection
    @connection ||= ::Faraday.new(url: base_url) do |f|
      f.request  :json
      f.response :json
      f.adapter  ::Faraday.default_adapter
    end
  end

  def get(path)
    response = connection.get("#{base_url}/#{path}") do |req|
      req.headers["Authorization"] = basic_auth_header
    end
    handle_response(response)
  end

  def post(path, ref:, payload:)
    response = connection.post("#{base_url}/#{path}?ref=#{ref}") do |req|
      req.headers["Authorization"] = basic_auth_header
      req.body = payload.to_json
    end
    handle_response(response)
  end

  def delete(path, payload:)
    response = connection.delete("#{base_url}/#{path}") do |req|
      req.headers["Authorization"] = basic_auth_header
      req.body = payload.to_json
    end
    handle_response(response)
  end

  def basic_auth_header
    encoded = Base64.strict_encode64("#{@token}:")
    "Basic #{encoded}"
  end

  def handle_response(response)
    return response.body if response.status.in?([ 200, 201, 202 ])
    raise ApiError.new("Focus NF-e API error #{response.status}", status: response.status, body: response.body)
  end
end
