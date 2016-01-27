class InvitationMailer < ActionMailer::Base

  def invite(invite)
      @subject        = invite.title
      @body["invite"] = invite
      @recipients     = invite.guest_email
      @from           = invite.host_email
      @sent_on        = Time.now
  end
  
end
