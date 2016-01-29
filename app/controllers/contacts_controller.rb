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

      ContactQuestionJob.perform_later(h) #sending mailer
      #ContactMailer.contact_email(h['name'],h['email'],h['comment']).deliver_later
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