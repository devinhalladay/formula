require 'sinatra'
require 'pony'

origin_domain = ENV['ORIGIN_DOMAIN'] # ENV['ORIGIN_DOMAIN'] should be formatted as http://domain.extension/
set :protection, :origin_whitelist => origin_domain # Only allow POST from specified origins. You may specify multiple whitelisted domains by separating domains in ENV['ORIGIN_DOMAIN'] by commas.

get '/' do
  redirect ENV['GET_REDIRECT_URL']
end

post '/' do
  Pony.mail({
    :from => params[:email],
    :to => ENV['RECIPIENT_EMAIL_ADDRESS'],
    :subject => "New email from your static form!",
    :body => erb(:email),
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
  })
  redirect ENV['POST_REDIRECT_URL'] # ENV['POST_REDIRECT_URL'] should be formatted as http://domain.extension/
end
