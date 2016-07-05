require "refile/s3"

aws = {
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: "us-east-1",
  bucket: ENV['S3_BUCKET_NAME']
}
#Refile.cache = Refile::S3.new(max_size: 5.megabytes, prefix: "cache", **aws)
#Refile.store = Refile::S3.new(prefix: "store", **aws)


# message_files = aws.merge({bucket: "message_files"})
# product_files = aws.merge({bucket: "product_files"})
# refile_caches = aws.merge({bucket: "refile_caches"})

Refile.backends["message_files_backend"] = Refile::S3.new(prefix: "store/message_files", **aws)
Refile.backends["product_files_backend"] = Refile::S3.new(prefix: "store/product_files", **aws)
Refile.backends["company_files_backend"] = Refile::S3.new(prefix: "store/company_files", **aws)
Refile.cache = Refile::S3.new(max_size: 10.megabytes, prefix: "cache", **aws)
Refile.cdn_host = ENV['CLOUDFRONT_URL']

# Refile.backends["message_files_backend"] = Refile::S3.new(prefix: "store/message_files", **aws)
# Refile.backends["product_files_backend"] = Refile::S3.new(prefix: "store/product_files", **aws)
# Refile.backends["company_files_backend"] = Refile::S3.new(prefix: "store/company_files", **aws)
# Refile.backends["message_files_cache"] = Refile::S3.new(max_size: 5.megabytes, prefix: "cache/message_files", **aws)
# Refile.backends["product_files_cache"] = Refile::S3.new(max_size: 5.megabytes, prefix: "cache/product_files", **aws)
# Refile.backends["company_files_cache"] = Refile::S3.new(max_size: 20.megabytes, prefix: "cache/company_files", **aws)
# Refile.cdn_host = ENV['CLOUDFRONT_URL']



