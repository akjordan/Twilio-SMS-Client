ENV['TWILIO_ACCOUNT_SID'] = 'XXXXXXXXXXX'
ENV['TWILIO_AUTH_TOKEN'] = 'XXXXXXXXXXX'
ENV['TWILIO_NUMBER'] = 'XXXXXXXXXXX'
ENV['RACK_USER'] = 'XXXXXXXXXXX'
ENV['RACK_PW'] = 'XXXXXXXXXXX'

# Configure environment variables for local------------------------------------
puts "Please copy paste these into your shell to test locally:\n" +
      "export TWILIO_ACCOUNT_SID=#{ENV['TWILIO_ACCOUNT_SID']}\n" +
      "export TWILIO_AUTH_TOKEN=#{ENV['TWILIO_AUTH_TOKEN']}\n" +
      "export TWILIO_NUMBER=#{ENV['TWILIO_NUMBER']}\n" +
      "export RACK_USER=#{ENV['RACK_USER']}\n" +
      "export RACK_PW=#{ENV['RACK_PW']}\n"


# Configure environment variables for Heroku-----------------------------------
system("heroku config:add TWILIO_ACCOUNT_SID=#{ENV['TWILIO_ACCOUNT_SID']} " \
      "TWILIO_AUTH_TOKEN=#{ENV['TWILIO_AUTH_TOKEN']} " \
      "TWILIO_NUMBER=#{ENV['TWILIO_NUMBER']} " \
      "RACK_USER=#{ENV['RACK_USER']} " \
      "RACK_PW=#{ENV['RACK_PW']} ")