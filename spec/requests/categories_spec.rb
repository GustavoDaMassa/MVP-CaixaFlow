require "rails_helper"

RSpec.describe "Categories", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:atendente) { create(:user) }

  describe "GET /categories" do
    context "when not authenticated" do
      it "redirects to login" do
        get categories_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns 200" do
        sign_in atendente
        get categories_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /categories" do
    context "when admin with valid params" do
      it "creates a category and redirects" do
        sign_in admin
        expect {
          post categories_path, params: { category: { name: "Salgados" } }
        }.to change(Category, :count).by(1)
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when admin with invalid params" do
      it "does not create and returns 422" do
        sign_in admin
        post categories_path, params: { category: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when atendente" do
      it "redirects to root" do
        sign_in atendente
        post categories_path, params: { category: { name: "Salgados" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /categories/:id" do
    let!(:category) { create(:category) }

    context "when admin" do
      it "destroys the category" do
        sign_in admin
        expect {
          delete category_path(category)
        }.to change(Category, :count).by(-1)
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when atendente" do
      it "redirects to root" do
        sign_in atendente
        delete category_path(category)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
