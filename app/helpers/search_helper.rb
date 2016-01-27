# app/helpers/search_helper.rb 
module SearchHelper
  def find_countries
    Venue.find_by_sql("select country, count(country)as count from venues "\
                        "group by country order by count DESC")    
  end
  
  def find_all_cities
    Venue.find_by_sql("select city, count(city)as count from venues group by "\
                        "city order by count DESC")    
  end
  
  def find_all_countries 
    Venue.find_by_sql("select country, count(country)as count "\
                        "from venues group by country order by count DESC ")    
  end 
  
  def count_country(c)
    Venue.find_by_sql("select count(*) as venue_count from venues where "\
                        "country  = \"" + c.country + "\"" )
  end 
  
  def count_city(c)
    Venue.find_by_sql("select count(distinct country) as venue_count "\
                        "from venues where country  = \"" + c.country + "\"" )
  end
     
  def find_cities(c)
    Venue.find_by_sql("select distinct city from venues where "\
                        "country = \"" + c + "\" order by city ")    
  end 
  
  def find_venues(t)
    Venue.find_by_sql("select * from venues where city = \"" + t + "\" "\
                        "order by title ")    
  end 

  def find_venues_by_agent(id)
    Venue.find_by_sql("select * from venues where agent_id ="\
                         " \"#{session["agent_id"]}\"")    
  end 
  
  def find_events(v)
    Event.find_by_sql("select * from events where venue_id" \
        " = \"" + v + "\" and ends >= CURRENT_DATE() order by ends ASC ")    
  end
  
  def find_event(e)
    Event.find(e)    
  end 
  
  def find_categories(c)
    @categories = Venue.find_by_sql("select distinct v_type, country from "\
                      "venues where country = \"" + c + "\" order by v_type")
  end
  
  def count_venues_by_co(co, cat)
    Venue.find_by_sql("select count(*)as count from venues where "\
                  "country =\"" + co + "\" and v_type = \"" + cat + "\"")
  end

  def count_venues_by_ci(ci, co)
    Venue.find_by_sql("select count(*)as count from venues where "\
                  "city =\"" + ci + "\" and country = \"" + co + "\"")
  end

  def count_venues_by_city(ci, cat)
    Venue.find_by_sql("select count(*)as count from venues where "\
                  "city =\"" + ci + "\" and v_type = \"" + cat + "\"")
  end

  def count_venues_by_cat_in_city(ci, co, cat)
    Venue.find_by_sql("select count(*)as count from venues where "\
                  "city =\"" + ci + "\" and country = \"" + co + "\" and  "\
                  "v_type = \"" + cat + "\"")
  end

  
  def find_cities_by_category(co, category)
    Venue.find_by_sql("select distinct city, v_type from venues where "\
                 "country = \"" + co + "\" and v_type =\"" +  category + "\" "\
                  "order by city ")
  end
 
  def find_by_category_in_city(ci, category)
    Venue.find_by_sql("select * from venues where city = \"" + ci + "\" and "\
                  "v_type = \"" +  category + "\"")
  end
  
  def count_venues_by_ci_by_cat(town, cat)
    Venue.find_by_sql("select count(*)as count from venues where "\
                  "city =\"" + town + "\" and v_type = \"" + cat + "\"")
  end 

  def count_current_events_by_venue_in_city(ven, cat)
    Event.find_by_sql("select count(*)as count from events where "\
                  "venue_id =\"" + ven + "\" and e_type = \"" + cat + "\" "\
                  " and ends >= CURRENT_DATE()")
  end
  
  def agent_owns_venue(v)
    if session[:user_id] and Venue.find(v).user_id == session[:user_id]
      true
    else
      nil
    end
  end
  
  def user_owns(sub, subject_id)
    if !session[:user_id]
      return false
    end 

    if User.find(session[:user_id]).level == 2
      return true
    end
    
    resu = false
    if sub == "private_event"
      if PrivateEvent.find(subject_id).user_id == session[:user_id]
        resu = false
      end
      return resu
    end
    if sub == "event"
      if Event.find(subject_id).user_id == session[:user_id]
        resu = true
      end
      return resu
    end
    if sub == "venue"
      if Venue.find(subject_id).user_id == session[:user_id]
        resu = true
      end
      return resu
    end
    return resu  
  end  
end
