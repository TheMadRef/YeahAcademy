class RtNewMemoMailer < ActionMailer::Base
  def new_memo_notice(participant, title, short_summary, url)
    @subject    = 'A New Memo has been added to RefTrack Online'
    @body["title"] = title
    @body["summary"] = short_summary
    @body["name"] = participant.first_name
    @body["url"] = url
    @recipients = participant.email
    @from       = 'FaciliTrax Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
