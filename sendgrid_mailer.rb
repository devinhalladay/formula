require 'sinatra'
require 'pony'

origin_domain = ENV['origin_domain']
set :protection, :origin_whitelist => origin_domain

get '/' do
  'Instead of looking at my form endpoint, why don\'t you go <a href="http://devinhalladay.com/contact">send me an email</a> instead?'
end

post '/' do
  email = ""
  params.each do |value|
    email += "#{value[0]}: #{value[1]}\n"
  end
  puts email
  Pony.mail({
    :to => ENV['recipient'],
    :from => 'noreply@example.com',
    :subject => 'New Contact Form',
    :body => email,
    :via => :smtp,
    :via_options => {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain         => "heroku.com" # the HELO domain provided by the client to the server
    }
  })
end
