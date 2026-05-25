require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  let(:admin)     { create(:user, :admin) }
  let(:atendente) { create(:user) }

  describe "GET /admin" do
    context "when not authenticated" do
      it "redirects to login" do
        get admin_root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as atendente" do
      it "redirects to root" do
        sign_in atendente
        get admin_root_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns 200" do
        get admin_root_path
        expect(response).to have_http_status(:ok)
      end

      it "displays payment method breakdown" do
        create(:order, payment_method: :pix, total: 50.0)
        create(:order, payment_method: :cash, total: 30.0)
        get admin_root_path
        expect(response.body).to include("Pix")
        expect(response.body).to include("Dinheiro")
      end

      it "displays recent orders" do
        customer = create(:customer, name: "João Teste")
        create(:order, customer: customer)
        get admin_root_path
        expect(response.body).to include("João Teste")
      end
    end
  end
end
