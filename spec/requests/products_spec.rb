require "rails_helper"

RSpec.describe "Products", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:atendente) { create(:user) }
  let(:category) { create(:category) }

  describe "GET /products" do
    context "when not authenticated" do
      it "redirects to login" do
        get products_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns 200" do
        sign_in atendente
        get products_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /products" do
    let(:valid_params) do
      { product: { name: "Pamonha", price: "8.50", stock: 50,
                   low_stock_threshold: 10, category_id: category.id } }
    end

    context "when admin with valid params" do
      it "creates a product and redirects" do
        sign_in admin
        expect { post products_path, params: valid_params }.to change(Product, :count).by(1)
        expect(response).to redirect_to(products_path)
      end
    end

    context "when admin with invalid params" do
      it "returns 422" do
        sign_in admin
        post products_path, params: { product: { name: "", price: "", category_id: category.id } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when atendente" do
      it "redirects to root" do
        sign_in atendente
        post products_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /products/:id" do
    let(:product) { create(:product, category: category) }

    context "when admin" do
      it "updates and redirects" do
        sign_in admin
        patch product_path(product), params: { product: { name: "Cural" } }
        expect(response).to redirect_to(products_path)
        expect(product.reload.name).to eq("Cural")
      end
    end
  end
end
