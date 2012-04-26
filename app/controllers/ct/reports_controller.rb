class Ct::ReportsController < ApplicationController

 	before_filter :require_id, :only => [ :family_report]

	def print_roster
		@ct_session = CtSession.find(params[:id])
		@ct_rosters = @ct_session.ct_rosters.find(:all)
	  @columns =  ParticipantFormOrder.find(:all, :order => 'sort_number', :conditions => ["show_on_reports = ?", true])		
	end
	
	def family_report
		@participant = Participant.find(params[:id])
		if @participant.participant.nil?
			@family_members = Participant.find(:all, :conditions => ["parent_id = ?", @participant.id])
		else
			@participant = Participant.find(@participant.parent_id)
			@family_members = Participant.find(:all, :conditions => ["parent_id = ?", @participant.id])
		end
		@first_date = CtReservation.minimum(:session_date, :conditions => ["session_date >= ?", Date.today])
	end
end
