class RtDirectoryMailer < ActionMailer::Base
  def directory_email(first_name,  last_name, email, subject, body)
    @subject    = subject
    @body["name"] = first_name + " " + last_name
    @body["body"] = body
    @recipients = email
    @from       = 'FaciliTrax Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
