require "rubygems"
require "twitter"

# Get a user's most recent status update
Twitter.configure do |config|
  config.consumer_key = "hU6a14Pienagb3SZVJzSw"
  config.consumer_secret = "wNaO8GM1AIKalatQw2iaeYAtuA9OkOJy3vftmWuh0TY"
end

# Update your status
Twitter.update("I Love ruby!")


