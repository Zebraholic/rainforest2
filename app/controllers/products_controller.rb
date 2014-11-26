class ProductsController < ApplicationController

  before_action :require_login, only: [:new, :edit, :create]

private
  def require_login
    unless current_user
      redirect_to new_session_url
    end
  end

public

  def index
    @products = Product.order('products.created_at DESC').page(params[:page])

    respond_to do |format|
      format.js # allows the controller to respond to Javascript
      format.html
    end
  end

  def show
    @product = Product.find(params[:id])
    if current_user
      @review = @product.reviews.build
    end
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_url
    else
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :price_in_cents)
  end
end

