require "refile/s3"

aws = {
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: "us-east-1",
  bucket: ENV['S3_BUCKET_NAME']
}
Refile.cache = Refile::S3.new(max_size: 5.megabytes, prefix: "cache", **aws)
Refile.store = Refile::S3.new(prefix: "store", **aws)
Refile.cdn_host = ENV['CLOUDFRONT_URL']

# message_files = aws_base.merge({bucket: "message_files"})
# product_files = aws_base.merge({bucket: "product_files"})
# refile_caches = aws_base.merge({bucket: "refile_caches"})

# Refile.backends["message_files_backend"] = Refile::S3.new(prefix: "store", **message_files)
# Refile.backends["product_files_backend"] = Refile::S3.new(prefix: "store", **product_files)
# Refile.backends["refile_caches_backend"] = Refile::S3.new(max_size: 5.megabytes, prefix: "cache", **refile_caches)