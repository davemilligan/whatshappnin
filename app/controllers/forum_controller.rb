##
#  The Forum Controller handles all traffic concerned with posting comments 
#  related to a given venue or event. 
#  This controller checks to ensure that the user calling the actions is 
#  indeed authorized to carry out those actions.
#  
class ForumController < ApplicationController
  before_filter :authorize_user
  layout 'whatshappnin'  
  
  ##
  # ensures that the controller only responds to requests
  # that come via an HTTP POST.
  # 
  verify :method => :post, :only => [ :post_comment,
                                      :post_reply,
                                      :destroy_comment,
                                      :destroy_reply, 
                                      ],
         :redirect_to => { :controller => 'agents' }
  
  ##
  # adds a comment
  # 
  def post_comment  
    comment = Comment.new(params[:comment])      
    comment.save
    redirect_to :back
  end

  ##
  # adds a reply to a comment
  # 
  def post_reply  
    reply = Comment.new(params[:reply]) 
    comment = Comment.find(reply.reply)
    reply.save      
    CommentAccessLog.find_all_by_comment_id(comment.id).each do |c|
      c.updated = true
      c.save
    end
    comment.save
    redirect_to :back
  end
  
  ##
  # deletes a comment and all related replies.
  # 
  def destroy_comment        
    Comment.delete_all(["reply = ?", params[:id]]) 
    Comment.find(params[:id]).destroy 
    redirect_to :back
  end
  
  ##
  # deletes a comment and all related replies.
  #   
  def destroy_reply
    Comment.find(params[:id]).destroy    
    redirect_to :back
  end    
  
end
