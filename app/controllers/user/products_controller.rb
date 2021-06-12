class User:: ProductsController < User::UserController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = @company.products.sort_by { |product| product.name }
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = @company.products.build(product_params)
    if @product.save
      redirect_to user_company_product_path(@company.token, @product)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = t('.success')
      redirect_to user_company_product_path(@company.token, @product)
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = t('.success')
    redirect_to user_company_products_path(@company.token)
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :pix_discount, 
                                    :card_discount, :boleto_discount)
  end

  def set_company
    @company = Company.find_by(token: params[:company_token])
  end

  def set_product
    @product = Product.find(params[:id])
    redirect_to root_path unless @product.company == @company
  end
end