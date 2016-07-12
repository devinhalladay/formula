require 'sinatra'
require 'pony'

# ENV['ORIGIN_DOMAIN'] should be formatted as http://domain.extension/
origin_domain = ENV['ORIGIN_DOMAIN']
set :protection, :origin_whitelist => origin_domain

get '/' do
  redirect ENV['GET_REDIRECT_URL']
end

post '/' do
  Pony.mail({
    :from => params[:email],
    :to => ENV['RECIPIENT_EMAIL_ADDRESS'],
    :subject => "New inquiry from #{params[:name]}",
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

  redirect ENV['REDIRECT_URL']
end
http://devinhalladay.com/contact#success
