class ContactMailer < ActionMailer::Base
  default to: 'faskyn@gmail.com'

  def contact_email(name, email, comment)
    @name = name
    @email = email
    @comment = comment

    mail(from: email, subject: 'Contact form message')
  end
end