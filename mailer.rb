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
  # Allow origin
  response['Access-Control-Allow-Origin'] = ENV['ORIGIN_DOMAIN']
  return jsonp

  # Initialize errors hash
  @errors = {}
  # Initialize data hash
  @data = {}
  # Set failure fallback to false
  @failure = false

  # These are just sample validations; feel free to add your own.

  if !valid_field?(params[:name])
    # Set the error for the field name="name" to an error warning string.
    @errors[:name] = 'Name is required.'
  end

  if !valid_field?(params[:email])
    @errors[:email] = 'Email is required.'
  end

  if !valid_field?(params[:message])
    @errors[:message] = 'Message is required.'
  end

  # Return a response

  # If there are errors
  if !@errors.empty?
    # Sets the success param to false
    @data[:success] = false
    # Sets tje errors param equal to the @errors hash
    @data[:errors] = @errors

  # If there are no errors
  else
    # Send the email!
    Pony.mail({
      :from => params[:email],
      :to => ENV['RECIPIENT_EMAIL_ADDRESS'],
      :subject => "New inquiry from #{params[:name]}",
      :body => erb(:email)
    })

    # Set the success param to true
    @data[:success] = true
    # Set the message param to a string
    @data[:message] = 'Success!'
  end
  # Return the full @data hash to JSON
  JSONP @data
end
