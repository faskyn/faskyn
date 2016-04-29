require "rails_helper"
#require "pry"

describe ContactsController do

  describe "when user is not logged in" do

    describe "GET new" do
      before(:each) do
        get :new
      end

      it "assigns contact" do
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template :new }
    end

    describe "POST create" do

      context "with valid attributes" do
        subject(:create_action) { post :create, contact: attributes_for(:contact) }

        it "saves the new contact in the db" do
          expect{ create_action }.to change{ Contact.count }.by(1)
        end

        it "redirects to contact page and shows the flash" do
          create_action
          expect(response).to redirect_to new_contact_path
          expect(controller).to set_flash[:notice].to("Message sent!")
        end
      end

      context "with invalid attributes" do
        subject(:create_action) { post :create, contact: attributes_for(:contact, name: nil) }

        it "doesn't save the new contact in the db" do
          expect{ create_action }.to_not change{ Contact.count }
        end

        it "renders new action" do
          expect(create_action).to render_template :new
        end
      end
    end
  end
end