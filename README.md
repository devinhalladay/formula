# formula

**A tiny Sinatra form endpoint for receiving POST requests from a form in a static site.**

---
I needed a lightweight, simple form endpoint for recieving emails from the contact form on my new website. I couldn't find anything I didn't have to pay for or that didn't have extraneous feature lists, so I made my own.

## Setup
Alright, let's get your form and endpoint up and running.

1. Clone this repo locally.
2. Run `bundle install` to install Sinatra and Pony, the app's only requirements.
3. Create a new Heroku application: `heroku apps:create your-app-name`
  - *Note: If you don't specify an app name, Heroku will create a random one for you, similar to the way GitHub does.*
4. Add the SendGrid addon to your app: `heroku addons:create sendgrid:starter`
5. Open `mailer.rb` and change the value of the `:subject` symbol to whatever you want your email subject to be.
  - You can pass Ruby to this string, for example, to return POST parameters: `:subject => "New email from #{params[:name]}!"` would show up in your inbox as an email with subject `"New email from Devin Halladay!"`
6. Open up the email view at `/views/email.erb` and replace the contents with the contents of your email. This can be HTML, Ruby code, etc. You can also pass in POST params just like you can in `:subject`
7. Push it up to Heroku: `git push heroku master`
8. Set all your environment variables in Heroku with `heroku config:set VAR_NAME="value"` (all required variables are listed below)
9. Set your form to `POST` to your new endpoint!
```html
<form action="http://appname.herokuapp.com/" method="POST">
  <input type="text" name="name">
  <input type="email" name="email">
  <textarea name="message"></textarea>
  <input type="submit">
</form>
```

## Environment variables
There are a few environment variables you'll need to set to get up and running. You can set them with `heroku config:set VAR_NAME="value"`

- `ORIGIN_DOMAIN` - A domain or list of domains (comma separated) from which the endpoint will allow `POST /`.
  - Should be formatted as `http://domain.extension/`
- `GET_REDIRECT_URL` - A URL (including protocol) that a user will be redirected to if they attempt to `GET /`
- `RECIPIENT_EMAIL_ADDRESS` - An email or list of emails (comma separated) to which the endpoint will send emails submitted via tyour static form.
- `POST_REDIRECT_URL` - Same as `RECIPIENT_EMAIL_ADDRESS`, except this is where the user will be redirected after a successful `POST /`
- `SENDGRID_USERNAME` and `SENDGRID_PASSWORD` are set automatically by Heroku when you add the SendGrid addon. You needn't worry about these.

## Roadmap
Eventually I plan on building this out into an equally simple plug-and-play form endpoint service so all you need to do is sign up, configure your endpoint options, and have it up and running without touching any backend code or Heroku nonsense. If you want to help with this, feel free to Tweet me or just submit a pull request.

[x] Server-side validation
[x] AJAX json responses

## Contributing
If you want to help out with development or you have a feature request, please follow these instructions:

1. Fork this repo.
2. Checkout a feature branch.
3. Make your changes on that feature branch.
4. Submit a pull request with full documentation of your changes.

I'll merge if I find the feature beneficial and the code up to par.
