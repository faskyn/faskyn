require "rails_helper"

describe Products::GroupInvitationsController do

  describe "when user is logged in" do
    
    before(:each) do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    describe "POST create" do
      let(:product) { create(:product, :product_with_nested_attrs, owner: @user) }
      before(:each) do
        request.env["HTTP_REFERER"] = product_product_owner_panels_path(product)
      end

      context "with vaild attributes" do

        describe "when user already invited or member" do
          let(:invited_user) { create(:user) }
          let!(:group_invitation_old) { create(:group_invitation, 
            sender: @user, recipient: invited_user, group_invitable: product, email: invited_user.email) }
          subject(:create_action) { post :create, product_id: product.id, group_invitation: attributes_for(:group_invitation, 
            sender: @user, recipient: invited_user, group_invitable: product, email: invited_user.email) } 

          it "doesn't create devise invitation" do
            expect{ create_action }.not_to change{ User.count }
          end

          it "doesn't create product invitation" do
            expect{ create_action }.not_to change{ GroupInvitation.count }
          end

          it "redirects to back and shows the flash" do
            create_action
            expect(response).to redirect_to product_product_owner_panels_path(product)
            expect(controller).to set_flash[:alert].to("User already invited!")
          end
        end

        describe "when user registered but not invited or member" do
          let!(:user) { create(:user) }
          subject(:create_action) { post :create, product_id: product.id, group_invitation: attributes_for(:group_invitation, 
            sender: @user, group_invitable: product, email: user.email) }

          it "doesn't creates devise invitation" do
            expect{ create_action }.to_not change{ User.count }
          end

          it "creates product invitation" do
            expect{ create_action }.to change{ GroupInvitation.count }.by(1)
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
      end
    end
  end
end
