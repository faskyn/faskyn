class ProductImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
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

  version :large_thumb do
    process resize_to_fill: [80, 80]
  end

  version :base_thumb, :from_version => :large_thumb do
    process resize_to_fill: [60, 60]
  end

  version :small_thumb, :from_version => :base_thumb do
   process :resize_to_fill => [45, 45]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    [version_name, "product_image.png"].compact.join('_')
  end

end
