# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_standard_flashes()
    if flash[:notice]
      flash_to_display, level = flash[:notice], 'notice'
      flash[:notice] = nil
    elsif flash[:warning]
      flash_to_display, level = flash[:warning], 'warning'
      flash[:warning] = nil
    elsif flash[:error]
      flash_to_display, level = flash[:error], 'error'
      flash[:error] = nil
    else
      return
    end
    content_tag 'div', flash_to_display, :class => "flash-#{level}", :id => "Flash"
  end

  def display_user_status
    if logged_in?
      greeting = "<h5>Welcome <span>#{current_user.login}</span>. | "
      greeting += "#{link_to 'My Account', { :controller => "/account", :action => :my_account }} | "
      if !current_user.admin
        greeting += "#{link_to 'My Profile', { :controller => "/account", :action => :my_profile }} | "      
        greeting += "#{link_to 'My Family', { :controller => "/account", :action => :my_family }} | "
        greeting += "#{link_to 'Shopping Cart', { :controller => "/shopping_cart", :action => :pending_items }} | "      
      end
      greeting += link_to 'Log Out', { :controller => "/account", :action => :logout }
    else
      greeting = "<h5>Welcome <span>Guest</span>.  | "
      greeting += link_to 'Sign Up', { :controller => "/account", :action => :signup }
      greeting += " | "
      greeting += link_to 'Log In', { :controller => "/account", :action => :login }
      greeting += "</h5>"
    end
    content_tag 'div', greeting, :id => "account"
  end  

  def find_divisions_for_league(league_id)
    @im_divisions = []
    @im_divisions = ImDivision.find(:all, :conditions => ["im_league_id = ?", league_id], :order => "im_day_of_play_id, division_name")
  end

  def build_division_count(division_id)
    division_count = ImTeam.number_of_teams_in_division(division_id)
    @division_full = false
    number_of_teams = ImDivision.find(division_id).number_of_teams
    if division_count < number_of_teams
      content_tag(:span, "#{division_count}/#{number_of_teams}", :class => "division_open")
    else
      @division_full = true
      content_tag(:span, "#{division_count}/#{number_of_teams}", :class => "division_closed")
    end
  end 
  
  def is_team_ready_to_pay(team_id)
    if !ImSetting.find(1).require_approval?
      im_team = ImTeam.find(team_id)
      if !im_team.im_division.nil?
        roster_minimum = im_team.im_division.im_league.im_sport.roster_minimum
        roster_price = im_team.im_division.im_league.im_sport.roster_price
      else
        roster_minimum = im_team.im_league.im_sport.roster_minimum
        roster_price = im_team.im_league.im_sport.roster_price
      end
      if !roster_price.nil?
        if ImRoster.paid_roster_count_for_team(team_id) < roster_minimum
          return false
        else
          return true
        end
      else
        if ImRoster.roster_count_for_team(team_id) < roster_minimum
          return false
        else
          return true
        end
      end
    else
      return true
    end
  end
  
  def is_category_allowed_in_session?(session_id)
		if current_user.admin
			return true
		elsif current_user.participant.category_id.nil?
 			@found_session = true
  		return true
  	elsif CtSession.is_category_restricted?(session_id, current_user.participant.category_id) && @family_members.nil? 
  		return false
		else
			if !CtSession.is_category_restricted?(session_id, current_user.participant.category_id)
	 			@found_session = true
				return true
			end			
 			for family_member in @family_members
 				if !CtSession.is_category_restricted?(session_id, family_member.category_id) 
		 			@found_session = true
		  		return true
				end
			end
  	end
  	return false
  end
  
  def does_user_have_pending_items?
  	return !LineItem.find(:first, :conditions => ["participant_id = ? AND order_id IS NULL", current_user.participant_id]).nil?
	end

	def are_there_active_class_registrations?
		return !CtSession.find(:first, :select => "id", :conditions => ["s_registration_start < ? AND s_registration_end > ?", Time.now, Time.now]).nil?
	end
	
	def are_there_future_class_registrations?
		return !CtSession.find(:first, :select => "id", :conditions => ["s_registration_start > ? ", Time.now]).nil?
	end
	
	def does_user_belong_to_classes?
		return !CtRoster.find(:first, :select =>"ct_rosters.id", :joins => "INNER JOIN participants ON ct_rosters.participant_id = participants.id", :conditions => ["ct_rosters.participant_id = ? OR participants.parent_id = ?", current_user.participant_id, current_user.participant_id]).nil?
	end
	
	def is_user_an_instructor?
		if !current_user.admin
			return current_user.participant.ct_instructor
		else
			return false
		end
	end	
	
	def is_user_a_power_user?
		return !RtParticipantUserGroupRelationship.find(:first, :select => "rt_user_groups.id", :joins => "INNER JOIN rt_user_groups ON rt_user_groups.id = rt_participant_user_group_relationships.rt_user_group_id", :conditions => ["rt_participant_user_group_relationships.participant_id = ? AND rt_user_groups.rt_user_group_type_id = ?", current_user.participant_id, 3]).nil?
	end

	def any_there_games_to_be_published?
		return !RtEmployeeSchedule.find(:first, :select => "rt_employee_schedules.id", :joins => "INNER JOIN im_games ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["im_games.game_time > ? AND rt_employee_schedules.status = ? AND NOT participant_id IS NULL", Date.today, 0]).nil? && ($g_require_game_acceptance || $g_send_game_notification_emails)
	end

  def display_custom_field_error?(custom_field_id)
  	if @rendering && @participant.custom_field_values[custom_field_id].blank? && !$g_admin
  		return true 
  	else
  		return false
  	end
  end

	def captain_name_for_team(id)
		team_captain = ImRoster.find(:first, :conditions => ["im_team_id = ? AND captain = ?", id, true])
		return team_captain.participant.last_name + ", " + team_captain.participant.first_name + " " + team_captain.participant.mi
	end

	def league_name_for_team(id)
		team = ImTeam.find_by_id(id)
		if team.im_division.nil?
			if team.im_league.im_league.nil?
				return team.im_league.league_name
			else
				return team.im_league.im_league.league_name + ":" + team.im_league.league_name
			end
		else
			if team.im_division.im_league.im_league.nil?
				return team.im_division.im_league.league_name
			else
				return team.im_division.im_league.im_league.league_name + ":" + team.im_division.im_league.league_name
			end
		end			
	end
	
	def league_name_for_division(id)
		division = ImDivision.find_by_id(id)
		if division.im_league.im_league.nil?
			return division.im_league.league_name
		else
			return division.im_league.im_league.league_name + ":" + team.im_division.im_league.league_name
		end
	end

	def playing_area_name(id)
		playing_area = PlayingArea.find_by_id(id)
		if playing_area.playing_area.nil?
			return playing_area.facility.facility_name + ":" + playing_area.playing_area_name
		else
			return playing_area.facility.facility_name + ":" + playing_area.playing_area.playing_area_name + ":" + playing_area.playing_area_name
		end			
	end

	def team_score_for_game(game, home_team)
		if home_team
			game_score = game.home_score
			if game.number_of_sets > 0
				game_score = game_score.to_s + " ("
				for set in 1..game.number_of_sets
					game_score = game_score + eval("game.home_set_#{set}").to_s
					if set != game.number_of_sets
						game_score = game_score + "-"
					end
				end
				game_score = game_score + ")"
			end
		else
			game_score = game.away_score
			if game.number_of_sets > 0
				game_score = game_score.to_s + " ("
				for set in 1..game.number_of_sets
					game_score = game_score + eval("game.away_set_#{set}"	).to_s
					if set != game.number_of_sets
						game_score = game_score + "-"
					end
				end
				game_score = game_score + ")"
			end			
		end
		return game_score
	end

	def email_list_for_game(employee_titles, game_date, game_time)
		first_email = true
		mail_link = "mailto:"
		for employee in employee_titles
			if !employee.participant.nil? && employee.status == 2
				if current_user.participant_id != employee.participant_id
					if first_email
						mail_link = mail_link + employee.participant.email
						first_email = false
					else
						mail_link = mail_link + ";" + employee.participant.email
					end
				end
			end
		end
		return mail_link + "?Subject=RefTrack Game on " + game_date + " " + game_time
	end

 	def emails_in_que
 		return Email.count
 	end
end
