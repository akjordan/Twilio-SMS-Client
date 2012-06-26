require 'sinatra'
require 'twilio-ruby'
require 'pg'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-postgres-adapter'


# Twilio credentials
account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']
from_number = ENV['TWILIO_NUMBER']

# set up a client to talk to the Twilio REST API
before '/sendsms' do
  @client = Twilio::REST::Client.new account_sid, auth_token
  @fromnum = from_number
end

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['RACK_USER'], ENV['RACK_PW']]
  end

end

DataMapper::setup(:default,ENV['PG_CREDENTIALS'])

class Sms
	include DataMapper::Resource
	property :id, Serial
	property :sid, String, :required => true
	property :from, String, :required => true
	property :body, Text, :required => true
	property :created_at, DateTime, :required => true
end

DataMapper.auto_upgrade!

get '/' do
	protected!
	@sms = Sms.all :order => :id.desc
	@title = 'SMS Notes' 
	erb :home
end

post '/sms' do
	n = Sms.new
	n.sid = params[:SmsSid]
	n.from = params[:From]
	n.body = params[:Body]
	n.created_at = Time.now
	n.save
	redirect to('/')
end

#wrap create in a try loop if 400 or 500 fail otherwise push into DB alternately use a route that reads the callback
#and pushes paramaters into the DB based on the status of the callback
#Do I want to set a status callback on this API call to check if the SMS was sucuessfull?
#What is the best way to cover the failure case and communicate it back to '/'
#

post '/sendsms' do
	protected!
	smsbody = params[:content]
	tonumber = params[:number]
	@client.account.sms.messages.create(
	  :from => @fromnum,
	  :to => tonumber,
	  :body => smsbody
	)
	n = Sms.new
	n.sid = '123456123'
	n.from = @fromnum
	n.body = smsbody
	n.created_at = Time.now
	n.save
	redirect to('/')
end