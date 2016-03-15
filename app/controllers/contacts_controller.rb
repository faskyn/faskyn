class ContactsController < ApplicationController
  layout "staticpages"

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      h = JSON.generate({ 'name' => params[:contact][:name],
                          'email' => params[:contact][:email],
                          'comment' => params[:contact][:comment] })

      ContactQuestionJob.perform_later(h)
      redirect_to new_contact_path, notice: "Message sent!"
    else
      render action: :new, alert: "Message couldn't be sent!"
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :comment)
    end
end