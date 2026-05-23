class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update]

  def index
    @q = Customer.ransack(params[:q])
    @customers = @q.result(distinct: true).order(:name).page(params[:page]).per(25)
  end

  def show; end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to customer_path(@customer), notice: "Cliente cadastrado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "Cliente atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, :email, :address, :notes)
  end
end
