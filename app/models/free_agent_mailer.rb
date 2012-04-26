class FreeAgentMailer  < ActionMailer::Base

  def invite(free_agent, url)
    @subject    = 'IMOnline Notification: New Free Agent Invitation'
    @body["free_agent"] = free_agent.first_name
    @body["url"] = MasterSetting.find(1).return_url
    @recipients = free_agent.email
    @from       = 'IMOnline Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def accept(captain, team_name, team_id, free_agent, url)
    @subject    = 'IMOnline Notification: A Free Agent Invitation has been Accepted'
    @body["captain"] = captain.first_name
    @body["free_agent"] = free_agent.first_name
    @body["team_name"] = team_name
    @body["team_id"] = team_id
    @body["url"] = MasterSetting.find(1).return_url
    @recipients = captain.email
    @from       = 'IMOnline Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def decline(captain, team_name, team_id, free_agent, url)
    @subject    = 'IMOnline Notification: A Free Agent Invitation has been Declined'
    @body["captain"] = captain.first_name
    @body["free_agent"] = free_agent.first_name
    @body["team_name"] = team_name
    @body["team_id"] = team_id
    @body["url"] = MasterSetting.find(1).return_url
    @recipients = captain.email
    @from       = 'IMOnline Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
end
