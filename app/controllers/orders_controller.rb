class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy update_status]

  def index
    @q = scoped_orders.ransack(params[:q])
    @orders = @q.result(distinct: true)
                .includes(:customer, :user)
                .order(created_at: :desc)
                .page(params[:page]).per(15)
  end

  def show; end

  def new
    @order = Order.new
    @order.order_items.build
    @products = Product.where(active: true).order(:name)
    @customers = Customer.order(:name)
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.total = OrderTotalCalculator.call(@order)

    if @order.save
      StockManager.decrement(@order)
      redirect_to order_path(@order), notice: "Pedido criado."
    else
      @products = Product.where(active: true).order(:name)
      @customers = Customer.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @products = Product.where(active: true).order(:name)
    @customers = Customer.order(:name)
  end

  def update
    if @order.update(order_params)
      @order.update!(total: OrderTotalCalculator.call(@order))
      redirect_to order_path(@order), notice: "Pedido atualizado."
    else
      @products = Product.where(active: true).order(:name)
      @customers = Customer.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.update!(status: :cancelled)
    StockManager.restore(@order)
    redirect_to orders_path, notice: "Pedido cancelado."
  end

  def update_status
    previous_status = @order.status
    if @order.update(status: params[:order][:status])
      handle_status_change(previous_status)
      redirect_to order_path(@order), notice: "Status atualizado."
    else
      redirect_to order_path(@order), alert: "Não foi possível atualizar o status."
    end
  end

  private

  def set_order
    @order = scoped_orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Pedido não encontrado."
  end

  def scoped_orders
    current_user.admin? ? Order.all : Order.where(user: current_user)
  end

  def order_params
    params.require(:order).permit(
      :customer_id, :notes, :scheduled_for,
      order_items_attributes: %i[id product_id quantity unit_price _destroy]
    )
  end

  def handle_status_change(previous_status)
    if @order.cancelled? && previous_status != "cancelled"
      StockManager.restore(@order)
    end
    if @order.ready? && @order.customer&.email.present?
      OrderReadyMailJob.perform_later(@order.id)
    end
  end
end
