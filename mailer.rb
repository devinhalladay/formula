require 'sinatra'
require 'sinatra/jsonp'
require 'pony'

before do
  # Set document content_type to json
  content_type :json
  headers 'Access-Control-Allow-Origin' => ENV['ORIGIN_DOMAIN'], # Allow access from ORIGIN_DOMAIN
          'Access-Control-Allow-Methods' => ['POST GET'] # Allow POST and GET from origin.
end

# Only allow requests from specified origins.
origin_domain = ENV['ORIGIN_DOMAIN']
set :protection, :origin_whitelist => origin_domain

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
  # Checks if a field's value exists and is not empty.
  def valid_field?(field_name)
    true if field_name && !field_name.empty?
  end
end

get '/' do
  redirect ENV['GET_REDIRECT_URL']
end

post '/' do
  return jsonp

  @errors = {}
  @failure = false

  # These are just sample validations; feel free to add your own.

  if !valid_field?(params[:name])
    # Add this param to the errors hash
    @errors[:name] = true
    # Set @failure = true for the mailer action conditional below.
    @failure = true
  end

  if !valid_field?(params[:email])
    @errors[:email] = true
    @failure = true
  end

  if !valid_field?(params[:message])
    @errors[:message] = true
    @failure = true
  end

  if @failure
    # If @failure is true, return @errors in the AJAX json response.
    return jsonp @errors
  else
    # If @faliure is false, send the email.
    Pony.mail({
      :from => params[:email],
      :to => ENV['RECIPIENT_EMAIL_ADDRESS'],
      :subject => "New email from your static form!",
      :body => erb(:email)
    })
  end

  # Return the json response via AJAX
  return jsonp true
end
