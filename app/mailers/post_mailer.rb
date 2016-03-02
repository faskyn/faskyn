class PostMailer < ActionMailer::Base

  def post_created(post, writer, reader)
    @post = post
    @writer = writer
    @reader = reader

    mail(from: '#{writer.email}',
         to: "#{reader.email}",
         subject: "[Faskyn] New post from #{writer.profile.full_name}"
         )
  end
end