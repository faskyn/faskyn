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

      PostmanWorker.perform_async(h, 5)
      #ContactMailer.contact_email(name, email, comment).deliver_later
      
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      flash[:danger] = "Error occured."
      render action: :new
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :comment)
    end
end