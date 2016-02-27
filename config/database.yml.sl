# SQLite version 3.x
#   gem install sqlite3
#
#   Ensure the SQLite 3 gem is defined in your Gemfile
#   gem 'sqlite3'
#
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: db/test.sqlite3

production:
  <<: *default
  database: db/production.sqlite3

#default: &default
#  adapter: mysql2
#  encoding: utf8
#  pool: 5
#  username: root
#  password:
#  socket: /var/lib/mysql/mysql.sock
#
#development:
#  <<: *default
#  database: demetra_development
#
#test:
#  <<: *default
#  database: demetra_test
#
#production:
#  <<: *default
#  database: demetra_production
#  username: root
#  password: <%= ENV['DEMETRA_DATABASE_PASSWORD'] %>
