class ProductsController < ApplicationController
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:category).order(:name).page(params[:page]).per(20)
  end

  def show; end

  def new
    @product = Product.new
    @categories = Category.order(:name)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Produto criado com sucesso."
    else
      @categories = Category.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.order(:name)
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Produto atualizado."
    else
      @categories = Category.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produto removido."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock,
                                    :low_stock_threshold, :active, :category_id, :image)
  end
end
