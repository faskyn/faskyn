class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fit => [400, 300]

  version :base_thumb do
    process resize_to_fill: [200, 150]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # def default_url
  #   [version_name, "post_image.png"].compact.join('_')
  # end
end
