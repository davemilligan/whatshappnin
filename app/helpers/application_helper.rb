# app/helpers/application_helper.rb 
module ApplicationHelper

 def res(n)
    begin
     @resource = Resource.find_by_name(n)
     if @resource.value =~ /\w*/i
        @resource.value
     else
        "<b class='missing-resource'>(#{n})</b>"
     end    
    rescue
     @resource = Resource.new
     @resource.name = n
     @resource.save
     "<b class='missing-resource'>(#{n})</b>"
    end 
 end 
 
 def insert_heading(text, other)
     other = "" unless other
     return "" +
     "<fieldset class='heading'><h2>" + 
        Resource.get(text) + " " + other +
     "</h2></fieldset>"
 end

 def insert_sidebar_heading(text)
     return "" + 
      "<fieldset class='side-bar-heading'><h2>" + 
        Resource.get(text) + 
      "</h2></fieldset>"
 end

 def insert_comment_heading(text)
     return "" + 
      "<fieldset class='side-bar-heading'><h2>" + 
        Resource.get(text) + 
      "</h2></fieldset>"
 end
 
 def which_questionaire
    @q = 0
    Questionaire.find(:all).each do|q|
     if q.activated
      @q = q.id
      break
     end
    end 
    return @q 
  end 
end
