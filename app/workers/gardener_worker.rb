require 'manybots-api-client'

class GardenerWorker
  @queue = :agents
  
  attr_accessor :user, :manybots_client
  
  def initialize(user_id)
    @user = User.find(user_id)
    @manybots_client = Manybots::Client.new(@user.authentication_token)
  end
  
  def items
    @items ||= self.manybots_client.notifications({verb: 'report', objectType: 'weather'}, 1, 50)['data']['items'] rescue(nil)
  end
  
  def as_notification(place)
    activity = {}
    activity[:notification] = {
      type: "Gardening alert",
      level: "Alert"
    }
    activity[:published] = Time.now.xmlschema
    activity[:title] = "You should water the plants today"
    activity[:auto_title] = true
    activity[:actor] = {
      displayName: 'Manybots Gardener',
      objectType: 'application',
      id: ManybotsGardener.app.url,
      url: ManybotsGardener.app.url,
      image: {
        url: ManybotsServer.url + ManybotsGardener.app.app_icon_url
      }
    }
    activity[:icon] = {
      :url => ManybotsServer.url + ManybotsGardener.app.app_icon_url
    }
    activity[:verb] = 'predict'
    activity[:provider] = {
      :displayName => 'Manybots Gardener',
      :url => ManybotsGardener.app.url,
      :image => {
        :url => ManybotsServer.url + ManybotsGardener.app.app_icon_url
      }
    }
    activity[:generator] = activity[:provider]
    activity[:object] = self.as_prediction_activity(place)
    activity[:target] = place
    
    activity
  end
  
  def as_prediction_activity(place)
    activity = {
      title: "ACTOR watered OBJECT at TARGET",
      displayName: "ACTOR watered OBJECT at TARGET",
      verb: 'water',
      auto_title: true,
      published: (Time.now.beginning_of_day + 20.hours).xmlschema,
      objectType: 'activity',
      id: "#{ManybotsGardener.app.url}/waterings/#{Time.now.to_i}",
      url: "#{ManybotsGardener.app.url}/waterings/#{Time.now.to_i}",
      icon: {
        url: ManybotsServer.url + ManybotsGardener.app.app_icon_url
      },
    }
    activity[:actor] = {
      displayName: self.user.name || self.user.email,
      objectType: 'person',
      id: "#{ManybotsServer.url}/users/#{self.user.id}",
      url: "#{ManybotsServer.url}/users/#{self.user.id}",
      image: {
        url: self.user.avatar_url
      }
    }
    
    activity[:object] = {
      displayName: 'Plants',
      objectType: 'plant',
      id: "#{ManybotsGardener.app.url}/gardens/#{self.user.id}",
      url: "#{ManybotsGardener.app.url}/gardens/#{self.user.id}",
    }
    activity[:target] = place
    activity[:provider] = {
      :displayName => 'Manybots Gardener',
      :url => ManybotsGardener.app.url,
      :image => {
        :url => ManybotsServer.url + ManybotsGardener.app.app_icon_url
      }
    }
    activity[:generator] = activity[:provider]
    
    activity
  end
  
  def post_to_manybots!(place)
    self.manybots_client.create_notification(self.as_notification(place))
  end
  
  def self.needs_watering?(condition)
    return false if condition.nil?
    by_condition = case condition['code'].to_i
    when 32, 34, 36
      true
    else
      false
    end
    by_temperature = case condition['temperature'].to_i
    when 18..60
      true
    else 
      false
    end
    by_condition or by_temperature
  end
  
  def self.perform(user_id)
    worker = self.new(user_id)
    return "no items" if worker.items.nil? or worker.items.empty?
    notifications = worker.items.group_by{|n| n['published'].to_date }.delete_if{|k,v| k.to_date != Date.today}
    notifications = notifications[Date.today].group_by{|n| n['target'] }
    results = []
    notifications.each do |place, notifs|
      results = notifs.collect{|n| self.needs_watering?(n['object']['condition'])}
      results.include?(true) ? worker.post_to_manybots!(place) : nil
    end
  end
  
  
  
end

