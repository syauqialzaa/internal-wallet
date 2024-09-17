class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :team_lead, :team_size
end