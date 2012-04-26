class ResetPasswordMailer  < ActionMailer::Base
  def reset_password(user, participant, url)
    @subject    = 'Your ClassTrack Online Reset Password Request'
    @body["user"] = user
    @body["participant"] = participant
    @body["url"] = url
    @recipients = participant.email
    @from       = 'ClassTrack Online Automated Email <tutormail@classtrackonline.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
