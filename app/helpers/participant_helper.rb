module ParticipantHelper
  def participant_in_user_group(participant_id, user_group_id)
    if participant_id.nil?
      return false
    else
      return !(RtParticipantUserGroupRelationship.find(:first, :conditions => ["participant_id = ? AND rt_user_group_id = ?", participant_id, user_group_id]).nil?)
    end
  end
end
