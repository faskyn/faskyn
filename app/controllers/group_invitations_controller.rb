class GroupInvitationsController < ApplicationController
  before_action :set_and_authorize_group_invitation, only: [:accept, :destroy]

  def new
  end

  def create
    authorize @product, :create_product_invitations?
    @recipient = User.invite!({ email: email }, @product.owner)
    if @recipient.is_invited_or_member?(@group_invitable)
      redirect_to :back, alert: "User already invited or team member!"
    else
      @group_invitation = @group_invitable.group_invitations.new(group_invitations_params)
      @group_invitation.sender = @product.owner
      @group_invitation.recipient = @recipient
      if @group_invitation.save
        Notification.create(
                            recipient_id: @group_invitation.recipient_id,
                            sender_id: @group_invitation.sender_id, 
                            notifiable: @group_invitable, 
                            action: "invited"
                            )
        GroupInvitationJob.perform_later(@group_invitation)
        redirect_to :back, notice: "Invitation sent!"
      else
        flash[:error] = "Type an email address!"
        redirect_to :back
      end
    end
  end

  def accept
    if @group_invitation.accepted == false
      @group_invitation.update_attribute(:accepted, true)
      if @group_invitation.group_invitable_type == "Product"
        ProductUser.create(
                          product_id: @group_invitation.group_invitable_id, 
                          user_id: @group_invitation.recipient_id, 
                          role: "member"
                          )
      elsif @group_invitation.group_invitable_type == "ProductCustomer"
        ProductCustomerUser.create(
                                  product_customer_id: @group_invitation.group_invitable_id,
                                  user_id: @group_invitation.recipient_id
                                  )
      end
      Notification.create(
                          recipient_id: @group_invitation.sender_id,
                          sender_id: @group_invitation.recipient_id, 
                          notifiable: @group_invitation.group_invitable, 
                          action: "accepted"
                          )
      redirect_to :back, notice: "Invitation accepted!"
    else
      redirect_to :back, notice: "Invitation is already accepted!"
    end
  end

  def destroy
    if @group_invitation.destroy
      redirect_to :back, notice: "Invitation got deleted!"
    else
      redirect_to :back, alert: "Invitation coludn't be deleted!"
    end
  end


  private

    def email
      params[:group_invitation][:email]
    end

    def group_invitations_params
      params.require(:group_invitation).permit(:email, :group_invitable_id, :group_invitable_type)
    end

    def set_and_authorize_group_invitation
      @group_invitation = GroupInvitation.find(params[:id])
      authorize @group_invitation
    end
end