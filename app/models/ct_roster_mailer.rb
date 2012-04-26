class CtRosterMailer < ActionMailer::ARMailer
  def email_roster(email, roster, class_name, session_name, columns)
    @subject    = "Class Roster for #{class_name}:#{session_name}"
    @body["class_name"] = class_name
    @body["session_name"] = session_name
    @body["rosters"] = roster
    @body["columns"] = columns    
    @recipients = email
    @from       = 'FaciliTrax Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def email_session_roster(first_name, last_name, email, subject, body)
    @subject    = subject
    @body["name"] = first_name + " " + last_name
    @body["body"] = body
    @recipients = email
    @from       = 'FaciliTrax Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
