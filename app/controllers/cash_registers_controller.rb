class CashRegistersController < ApplicationController
  before_action :require_admin, only: %i[destroy]
  before_action :set_cash_register, only: %i[show close]

  def index
    @cash_registers = CashRegister.recent.includes(:user).page(params[:page]).per(20)
    @current = CashRegister.current
  end

  def show; end

  def new
    if CashRegister.current
      redirect_to cash_registers_path, alert: "Já existe um caixa aberto."
    else
      @cash_register = CashRegister.new(opening_amount: 0)
    end
  end

  def create
    @cash_register = CashRegister.new(open_params)
    @cash_register.user = current_user
    @cash_register.opened_at = Time.current

    if @cash_register.save
      redirect_to cash_registers_path, notice: "Caixa aberto com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def close
    unless @cash_register.open?
      return redirect_to cash_registers_path, alert: "Este caixa já está fechado."
    end

    if @cash_register.update(close_params.merge(closed_at: Time.current))
      redirect_to cash_register_path(@cash_register), notice: "Caixa fechado."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_cash_register
    @cash_register = CashRegister.find(params[:id])
  end

  def open_params
    params.require(:cash_register).permit(:opening_amount, :notes)
  end

  def close_params
    params.require(:cash_register).permit(:closing_amount, :notes)
  end
end
