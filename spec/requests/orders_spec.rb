require "rails_helper"

RSpec.describe "Orders", type: :request do
  let(:admin)     { create(:user, :admin) }
  let(:atendente) { create(:user) }

  describe "GET /orders" do
    it "redirects to login when not authenticated" do
      get orders_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns 200 when authenticated" do
      sign_in atendente
      get orders_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /orders" do
    let(:product) { create(:product) }
    let(:valid_params) do
      {
        order: {
          payment_method: "cash",
          order_items_attributes: [
            { product_id: product.id, quantity: 2, unit_price: product.price }
          ]
        }
      }
    end

    before { create(:cash_register, user: admin) }

    it "creates order and redirects" do
      sign_in atendente
      expect { post orders_path, params: valid_params }.to change(Order, :count).by(1)
      expect(response).to redirect_to(order_path(Order.last))
    end

    it "associates the current user to the order" do
      sign_in atendente
      post orders_path, params: valid_params
      expect(Order.last.user).to eq(atendente)
    end
  end

  describe "atendente scoping" do
    it "atendente only sees own orders" do
      other = create(:user)
      create(:order, user: other)
      sign_in atendente
      get orders_path
      expect(response.body).not_to include(other.email)
    end
  end
end
