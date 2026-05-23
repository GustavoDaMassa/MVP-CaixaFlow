require "rails_helper"

RSpec.describe "Customers", type: :request do
  let(:user) { create(:user) }

  describe "GET /customers" do
    it "redirects to login when not authenticated" do
      get customers_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns 200 when authenticated" do
      sign_in user
      get customers_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /customers" do
    context "with valid params" do
      it "creates customer and redirects" do
        sign_in user
        expect {
          post customers_path, params: { customer: { name: "Maria", phone: "62999999999" } }
        }.to change(Customer, :count).by(1)
        expect(response).to redirect_to(customer_path(Customer.last))
      end
    end

    context "with invalid params" do
      it "returns 422" do
        sign_in user
        post customers_path, params: { customer: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
