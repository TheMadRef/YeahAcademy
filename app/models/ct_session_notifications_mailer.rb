class CtSessionNotificationsMailer < ActionMailer::ARMailer
  def cancel_session(participant_id, ct_session_id, session_date, start_time, facility)
    @subject    = 'ClassTrack Online Notification: Session Cancelled'
    participant = Participant.find_by_id(participant_id)
    @body["participant"] = participant.first_name
    session = CtSession.find_by_id(ct_session_id)
    @body["session_name"] = "#{session.ct_class.class_name}:#{session.s_class_name}"
    @body["session_date"] = session_date
    @body["start_time"] = start_time
    @body["facility"] = facility
    @recipients = participant.email
    @from       = 'ClassTrack Online Automated Email <tutormail@classtrackonline.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
