class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fit => [400, 400]

  version :base_thumb do
    process resize_to_fill: [85, 85]
  end

  version :small_thumb, :from_version => :base_thumb do
   process :resize_to_fill => [40, 40]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    [version_name, "default.png"].compact.join('_')
  end
end
