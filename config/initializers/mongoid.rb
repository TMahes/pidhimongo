Mongoid.load!(Rails.root.join("config/mongoid.yml"))
Mongoid.logger = Logger.new($stdout)
Mongo::Logger.logger = Logger.new($stdout)