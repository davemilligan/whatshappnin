class Agent
  
  def self.destroy_event(id)
    begin
      @event = Event.find(id)
      Comment.find_all_by_subject_id(@event.id).each do |c|
        Comment.delete_all(["reply = ?", @c.id])      
      end
      Comment.delete_all(["subject_id = ?", @event.id])
      @event.destroy    
    rescue
      
    end
  
  end  

  def self.destroy_venue(id)
    begin
      @venue = Venue.find(id)    
      Event.find_all_by_venue_id(@venue.id).each do |e|
        Comment.find_all_by_subject_id(e.id).each do |c|
          Comment.delete_all(["reply = ?", @c.id])      
        end
        Comment.delete_all(["subject_id = ?", e.id])
        e.destroy
      end
      Comment.find_all_by_subject_id(@venue.id).each do |c|
        Comment.delete_all(["reply = ?", @c.id])      
      end
      Comment.delete_all(["subject_id = ?", @venue.id])
      @venue.destroy 
   rescue
    
   end
  
  end  
  
end
