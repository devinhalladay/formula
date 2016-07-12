require 'sinatra'
require 'sinatra/jsonp'
require 'pony'

before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => ENV['ORIGIN_DOMAIN'],
          'Access-Control-Allow-Methods' => ['POST GET']
end

origin_domain = ENV['ORIGIN_DOMAIN']
set :protection, :origin_whitelist => origin_domain # Only allow POST from specified origins.

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address              => 'smtp.sendgrid.net',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => ENV['SENDGRID_USERNAME'],
    :password             => ENV['SENDGRID_PASSWORD'],
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "heroku.com" # the HELO domain provided by the client to the server
  }
}

helpers do
  def valid_name?(name)
    true if name && !name.empty?
  end

  def valid_email?(email)
    email_match = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/
    true if email && !(email =~ email_match).nil?
  end

  def valid_message?(message)
    true if message && !message.empty?
  end
end

get '/' do
  redirect ENV['GET_REDIRECT_URL']
end

post '/' do
  return jsonp

  @errors = {}
  @failure = false

  if !valid_name?(params[:name])
    @errors[:name] = true
    @failure = true
  end

  if !valid_email?(params[:email])
    @errors[:email] = true
    @failure = true
  end

  if !valid_message?(params[:message])
    @errors[:message] = true
    @failure = true
  end

  if @failure
    return jsonp @errors
  else
    Pony.mail({
      :from => params[:email],
      :to => ENV['RECIPIENT_EMAIL_ADDRESS'],
      :subject => "New email from your static form!",
      :body => erb(:email)
    })
    redirect ENV['POST_REDIRECT_URL']
  end

  return jsonp true
end
