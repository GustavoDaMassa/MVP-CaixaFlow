class FiscalConfigurationsController < ApplicationController
  before_action :require_admin!

  def show
    @fiscal_configuration = FiscalConfiguration.current || FiscalConfiguration.new
  end

  def edit
    @fiscal_configuration = FiscalConfiguration.current || FiscalConfiguration.new
  end

  def update
    @fiscal_configuration = FiscalConfiguration.current || FiscalConfiguration.new
    attrs = fiscal_configuration_params
    attrs = attrs.except(:focus_nfe_token) if attrs[:focus_nfe_token].blank?
    @fiscal_configuration.assign_attributes(attrs)
    if @fiscal_configuration.save
      redirect_to fiscal_configuration_path, notice: "Configuração fiscal salva."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Acesso restrito." unless current_user.admin?
  end

  def fiscal_configuration_params
    params.require(:fiscal_configuration).permit(
      :cnpj, :ie, :im, :razao_social, :nome_fantasia, :regime_tributario,
      :logradouro, :numero, :complemento, :bairro, :municipio, :uf, :cep,
      :codigo_municipio, :cfop_padrao, :serie_nfe, :focus_nfe_token
    )
  end
end
