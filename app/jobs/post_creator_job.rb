class PostCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(post_id, writer_id, reader_id)
    post = Post.find(post_id)
    writer = User.find(writer_id)
    reader = User.find(reader_id)
    PostMailer.post_created(post, writer, reader).deliver
  end
end