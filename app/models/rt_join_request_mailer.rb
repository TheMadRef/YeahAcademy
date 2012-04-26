class RtJoinRequestMailer < ActionMailer::Base

  def admin_invite(participant, url)
    @subject    = 'RefTrack Online Notification: You have been added'
    @body["participant"] = participant.first_name
    @body["url"] = url
    @recipients = participant.email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def request(participant, url, email)
    @subject    = 'RefTrack Online Notification: Request for Access'
    @body["participant"] = participant
    @body["url"] = url
    @recipients = email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def accept(participant)
    @subject    = 'RefTrack Online Notification: Request for Access Approved'
    @body["participant"] = participant.first_name
    @recipients = participant.email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def decline(participant)
    @subject    = 'RefTrack Online Notification: Request for Access Denied'
    @body["participant"] = participant.first_name
    @recipients = participant.email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
