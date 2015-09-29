class ContactMailer < ActionMailer::Base
  default to: 'faskyn@gmail.com'

  def contact_email(name, email, content)
    @name = name
    @email = email
    @content = content

    mail(from: email, subject: 'Contact form message')
  end
end