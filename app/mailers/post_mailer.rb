class PostMailer < ActionMailer::Base
  default from: 'faskyn@gmail.com'

  def post_created(post, writer, reader)
    @post = post
    @writer = writer
    @reader = reader

    mail(
        to: "#{reader.email}",
        subject: "[Faskyn] New post from #{writer.profile.full_name}"
        )
  end
end