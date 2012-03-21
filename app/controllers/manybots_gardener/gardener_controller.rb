module ManybotsGardener
  class GardenerController < ApplicationController
    before_filter :authenticate_user!
    
    def index
      load_schedule(current_user)
    end
    
    def toggle
      load_schedule(current_user)
      if @schedule == true
        ManybotsServer.queue.remove_schedule @schedule_name
        redirect_to root_path, :notice => 'Gardening alerts stopped.'
      else
        ManybotsServer.queue.add_schedule @schedule_name, {
          :every => '24h', 
          :first_at => first_at_1pm.to_s,
          :class => "GardenerWorker",
          :queue => "agents",
          :args => current_user.id,
          :description => "This job will predict and notify user ##{current_user.id} if they should water the plants every day at 1pm"
        }
        
        if first_at_1pm < Time.now 
          ManybotsServer.queue.enqueue(GardenerWorker, current_user.id) 
        end
          
        redirect_to root_path, :notice => 'Gardening alerts scheduled every day at 1pm.'
      end
    end
    
    private
      def load_schedule(user)
        schedules = ManybotsServer.queue.get_schedules
        @schedule_name = "import_manybots_gardener_#{current_user.id}"
        @schedule = schedules.keys.include?(@schedule_name) rescue(false)
      end
      
      def first_at_1pm
        today_1pm = Time.now.beginning_of_day + 13.hours
        (today_1pm > Time.now) ? (today_1pm - 1.day) : today_1pm
      end
    
    
  end
end
