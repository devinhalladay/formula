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
