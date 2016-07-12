# middleman-contact

**A tiny Sinatra form endpoint for receiving POST requests from a form in a static site.**

---
I needed a lightweight, simple form endpoint for recieving emails from the contact form on my new website. I couldn't find anything I didn't have to pay for or that didn't have extraneous feature lists, so I made my own.

## Setup
Alright, let's get your form and endpoint up and running.

1. Clone this repo locally.
2. Run `bundle install` to install Sinatra and Pony, the app's only requirements.
3. Create a new Heroku application: `heroku apps:create your-app-name`
  - *Note: If you don't specify an app name, Heroku will create a random one for you, similar to the way GitHub does.*
4. Open `mailer.rb` and change the value of the `:subject` symbol to whatever you want your email subject to be.
  - You can pass Ruby to this string, for example, to return POST parameters: `:subject => "New email from #{params[:name]}!"` would show up in your inbox as an email with subject `"New email from Devin Halladay!"`
5. Open up the email view at `/views/email.erb` and replace the contents with the contents of your email. This can be HTML, Ruby code, etc. You can also pass in POST params just like you can in `:subject`
6. Push it up to Heroku: `git push heroku master`
7. Set all your environment variables in Heroku with `heroku config:set VAR_NAME="value"` (all required variables are listed below)
8. Set your form to POST to your new endpoint!
  - ```
    <form action="http://appname.herokuapp.com" method="POST">
      <input type="text" name="fname">
      <input type="email" name="email">
      <textarea name="message"></textarea>
      <input type="submit">
    </form>
    ```
9. Test it out!
10. Profit.
