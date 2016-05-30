require "rails_helper"

describe Products::ProductInvitationsController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "POST create" do
      let(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: @user.id) }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end

      context "with vaild attributes" do

        describe "when user already invited or member" do
          let(:invited_user) { create(:user) }
          let!(:product_invitation_old) { create(:product_invitation, 
            sender_id: @user.id, recipient_id: invited_user.id, email: invited_user.email, product_id: product.id) }
          subject(:create_action) { post :create, product_id: product.id, product_invitation: attributes_for(:product_invitation, 
            sender_id: @user.id, email: invited_user.email) } 

          it "doesn't create devise invitation" do
            expect{ create_action }.not_to change{ User.count }
          end

          it "doesn't create product invitation" do
            expect{ create_action }.not_to change{ ProductInvitation.count }
          end

          it "redirects to back and shows the flash" do
            create_action
            expect(response).to redirect_to product_product_owner_panels_path(product)
            expect(controller).to set_flash[:alert].to("User already invited or team member!")
          end
        end

        describe "when user registered but not invited or member" do
          let!(:user) { create(:user) }
          subject(:create_action) { post :create, product_id: product.id, product_invitation: attributes_for(:product_invitation, 
            sender_id: @user.id, email: user.email, product_id: product.id) }

          it "doesn't creates devise invitation" do
            expect{ create_action }.to_not change{ User.count }
          end

          it "creates product invitation" do
            expect{ create_action }.to change{ ProductInvitation.count }.by(1)
          end

          it "sends notification" do
            expect{ create_action }.to change{ Notification.count }.by(1)
          end

          it "sends product invitation emal" do
            expect{ create_action }.to change{ ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
          end

          it "redirects to back and shows the flash" do
            create_action
            expect(response).to redirect_to product_product_owner_panels_path(product)
            expect(controller).to set_flash[:notice].to("Invitation sent!")
          end
        end

        describe "when user is not registered" do
          subject(:create_action) { post :create, product_id: product.id, product_invitation: attributes_for(:product_invitation,
            sender_id: @user.id, email: "not_registered@gmail.com", product_id: product.id) }

          it "creates devise invitation" do
            expect{ create_action }.to change{ User.count }.by(1)
          end

          it "creates product invitation" do
            expect{ create_action }.to change{ ProductInvitation.count }.by(1)
          end

          it "creates notification" do
            expect{ create_action }.to change{ Notification.count }.by(1)
          end

          it "creates product invitation emal" do
            expect{ create_action }.to change{ ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
          end

          it "redirects to back with flash" do
            create_action
            expect(response).to redirect_to product_product_owner_panels_path(product)
            expect(controller).to set_flash[:notice].to("Invitation sent!")
          end
        end
      end

      context "with invalid attributes" do
        let(:product) { create(:product, :product_with_nested_attrs) }
        let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: @user.id) }
        let(:attrs) { attributes_for(:product_user, sender_id: @user.id, email: "") }
        before(:each) do
          request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
        end
        subject(:create_action) { post :create, product_id: product.id, product_invitation: attrs }

        it "redirects to back with flash" do
          create_action
          expect(response).to redirect_to product_product_owner_panels_path(product)
          expect(controller).to set_flash[:error].to("Type an email address!")
        end
      end
    end

    describe "PATCH accept" do
      let!(:sender) { create(:user) }
      let!(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: sender.id) }
      let!(:product_invitation) { create(:product_invitation, product_id: product.id,
        sender_id: sender.id, recipient_id: @user.id, email: @user.email) }
      before(:each) do
        request.env["HTTP_REFERER"] = product_path(product)
      end

      it "assigns product invitation" do
        patch :accept, product_id: product.id, id: product_invitation.id, product_invitation: attributes_for(:product_invitation)
        expect(assigns(:product_invitation)).to eq(product_invitation)
      end

      it "updates product invitation" do
        patch :accept, product_id: product.id, id: product_invitation.id, product_invitation: attributes_for(:product_invitation, accepted: true)
        product_invitation.reload
        expect(product_invitation.accepted).to eq(true)
      end

      it "creates product user" do
        expect{ patch :accept, product_id: product.id, id: product_invitation.id, 
          product_invitation: attributes_for(:product_invitation, accepted: true) }.to change{ ProductUser.count }.by(1)
      end

      it "creates notification" do
        expect{ patch :accept, product_id: product.id, id: product_invitation.id, 
          product_invitation: attributes_for(:product_invitation, accepted: true) }.to change{ Notification.count }.by(1)
      end
    end

    describe "DELETE destroy" do
      let!(:sender) { create(:user) }
      let!(:product) { create(:product, :product_with_nested_attrs) }
      let!(:owner) { create(:product_user, product_id: product.id, role: "owner", user_id: sender.id) }
      let!(:product_invitation) { create(:product_invitation, product_id: product.id,
        sender_id: sender.id, recipient_id: @user.id, email: @user.email) }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end
      subject(:destroy_action) { delete :destroy, product_id: product.id, id: product_invitation.id }

      it "destroys the invitation" do
        expect { destroy_action }.to change{ ProductInvitation.count }.by(-1)
      end

      it "redirects to referer" do
        destroy_action
        expect(response).to redirect_to product_product_owner_panels_path(product)
        expect(controller).to set_flash[:notice].to("Invitation got deleted!")
      end
    end
  end
end