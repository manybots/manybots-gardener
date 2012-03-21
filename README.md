# Manybots Gardener Agent

manybots-gardener is a Manybots Agent that predicts and notifies you when you need to water the plants, based on weather conditions it finds on your Manybots account for each day.

To use this Agent, you should use a weather observer like the [Manybots Weather Observer](https://github.com/manybots/manybots-weather).

## Installation instructions

### Setup the gem

You need the latest version of Manybots Local running on your system. Open your Terminal and `cd` into its' directory.

First, require the gem: edit your `Gemfile`, add the following, and run `bundle install`

```
gem 'manybots-gardener', :git => 'git://github.com/manybots/manybots-weather.git'
```

Second, run the manybots-gardener install generator (mind the underscore):

```
rails g manybots_gardener:install
```

### Restart and go!

Restart your server and you'll see the Gardener Agent in your `/apps` catalogue. 

Go to the app to start the agent, and take good care of those plants!