class Products::ProductInvitationsController < ApplicationController
  before_action :set_product
  before_action :set_and_authorize_product_invitation, only: [:accept, :destroy]

  def new
    authorize @product, :new_product_invitations?
    @product_invitations = @product.product_invitations.order(created_at: :desc)
  end

  def create
    authorize @product, :create_product_invitations?
    @recipient = User.invite!({ email: email }, @product.owner)
    if @recipient.is_invited_or_team_member?(@product)
      redirect_to :back, alert: "User already invited or team member!"
    else
      @product_invitation = @product.product_invitations.new(product_invitations_params)
      @product_invitation.sender = @product.owner
      @product_invitation.recipient = @recipient
      if @product_invitation.save
        Notification.create(recipient_id: @product_invitation.recipient_id,
          sender_id: @product_invitation.sender_id, notifiable: @product, action: "invited")
        ProductInvitationJob.perform_later(@product_invitation)
        redirect_to :back, notice: "Invitation sent!"
      else
        flash[:error] = "Type an email address!"
        redirect_to :back
      end
    end
  end

  def accept
    if @product_invitation.accepted == false
      @product_invitation.update_attribute(:accepted, true)
      ProductUser.create(product_id: @product.id, user_id: @product_invitation.recipient_id, role: "member")
      Notification.create(recipient_id: @product_invitation.sender_id,
                            sender_id: @product_invitation.recipient_id, notifiable: @product, action: "accepted" )
      redirect_to :back, notice: "Invitation accepted!"
    else
      redirect_to :back, notice: "Invitation is alredy accepted!"
    end
  end

  def destroy
    if @product_invitation.destroy
      redirect_to :back, notice: "Invitation got deleted!"
    else
      redirect_to :back, alert: "Invitation coludn't be deleted!"
    end
  end


  private

    def email
      params[:product_invitation][:email]
    end

    def product_invitations_params
      params.require(:product_invitation).permit(:email)
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_and_authorize_product_invitation
      @product_invitation = ProductInvitation.find(params[:id])
      authorize @product_invitation
    end
end