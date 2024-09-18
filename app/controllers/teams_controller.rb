class TeamsController < ApplicationController
  before_action :authorized, only: [:create]
  before_action :set_team_lead
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    team = Team.create!(name: params[:name], team_lead: @team_lead.id, team_size: 1)
    team.create_entity!
    Wallet.create!(walletable: team.entity)

    render json: {
      team: TeamSerializer.new(team)
    }, status: :created
  end

  private
  def set_team_lead
    @team_lead = User.find_by_id(current_user&.id)
  end

  def handle_invalid_record(error)
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_record_not_found(error)
    render json: { error: 'Team not found' }, status: :not_found
  end
end
