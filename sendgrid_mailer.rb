require 'sinatra'
require 'pony'

origin_domain = ENV['origin_domain']
set :protection, :origin_whitelist => origin_domain

get '/' do
  redirect 'http://devinhalladay.com/contact'
end

post '/' do
  Pony.mail({
    :to => ENV['recipient'],
    :from => params[:email],
    :subject => "New inquiry from #{params[:name]}",
    :body => erb(:email),
    :via => :smtp,
    :via_options => {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain         => "heroku.com", # the HELO domain provided by the client to the server
      :enable_starttls_auto => true
    }
  })

  redirect 'http://devinhalladay.com/contact#success'
end
