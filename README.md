Closeio Sms Reminder is an app that let you fetch  your Close.io database every 10 minutes and that sends SMS and Email reminders to your customers. 

It sends an iCal invitation and an SMS reminder to your Leads with which you will have a meeting. 

# Example:

In case you create a task containing a specific keyword (in our case is "[Meeting]"),
Closeio Sms Reminder will instantly send an email containing the iCal invitation to the customer and, one hour before the meeting, it will also send and SMS reminder.

If your Task in Close.io contains a specific Keyword and the Lead has have a valid phone number set to "mobile" or a valid email address, than the reminder will be sent out.


# Configuration:

Wha will you need to run Closeio Sms Reminder:

1. Nexmo.com API KEY and SECRET
2. Close.io API KEY
3. SMTP server

Set the config variables in database.yml and secrets.yml

# Than run:

rake db:create db:migrate db:seed

# Test:

Run "rspec" in the root directory

# Services used:

- NEXMO API
- CLOSEIO API
- DELAYED JOB GEM
- CLOCKWORK

# Deployment instructions

1. Clone the repo locally
2. Run "rake db:migrate db:seed"
3. Set config variable in the config files (for Nexmo, Close.io and MAIL)
4. Run "rspec"
5. Run "bundle exec clockwork lib/clock.rb" to make it working locally


# How to use the app:

1. Set up the application and run "bundle exec clockwork lib/clock.rb"
2. Create a new Lead in CLose.io with a phonenumber set to "Mobile" and a valid a email address
3. Create a task in Close.io containing your desired keyword


Closeio Sms Reminder is made available under the terms of the GNU Affero General Public License 3.0 (AGPL 3.0). For other license contact us.
