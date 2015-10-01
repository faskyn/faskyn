web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -c 5 -v
privat_pub: rackup private_pub.ru -s puma -E production
redis: redis-server
puma: rails s Puma