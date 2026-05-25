require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }
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
      it "returns 200" do
        sign_in admin
        get admin_root_path
        expect(response).to have_http_status(:ok)
      end

      it "displays orders today by status" do
        create(:order, status: :pending)
        create(:order, status: :ready)
        sign_in admin
        get admin_root_path
        expect(response.body).to include("Pending")
        expect(response.body).to include("Ready")
      end

      it "displays low stock products" do
        create(:product, :low_stock, name: "Pamonha Especial")
        sign_in admin
        get admin_root_path
        expect(response.body).to include("Pamonha Especial")
      end

      it "displays recent orders" do
        create(:order)
        sign_in admin
        get admin_root_path
        expect(response.body).to include("Balcão")
      end
    end
  end
end
