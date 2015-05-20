require 'active_mocker/mock'

class TeamgifMock < ActiveMocker::Mock::Base
  created_with('1.8.3')

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "gif_id"=>nil, "team_id"=>nil, "votes"=>25, "created_at"=>nil, "updated_at"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, gif_id: Fixnum, team_id: Fixnum, votes: Fixnum, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:gif=>nil, :team=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"Gif"=>{:belongs_to=>[:gif]}, "Team"=>{:belongs_to=>[:team]}}.merge(super)
    end

    def mocked_class
      "Teamgif"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "gif_id", "team_id", "votes", "created_at", "updated_at"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "teamgifs" || super
    end

  end

  ##################################
  #   Attributes getter/setters    #
  ##################################

  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def gif_id
    read_attribute(:gif_id)
  end

  def gif_id=(val)
    write_attribute(:gif_id, val)
  end

  def team_id
    read_attribute(:team_id)
  end

  def team_id=(val)
    write_attribute(:team_id, val)
  end

  def votes
    read_attribute(:votes)
  end

  def votes=(val)
    write_attribute(:votes, val)
  end

  def created_at
    read_attribute(:created_at)
  end

  def created_at=(val)
    write_attribute(:created_at, val)
  end

  def updated_at
    read_attribute(:updated_at)
  end

  def updated_at=(val)
    write_attribute(:updated_at, val)
  end

  ##################################
  #         Associations           #
  ##################################

# belongs_to
  def gif
    read_association(:gif) || write_association(:gif, classes('Gif').try{ |k| k.find_by(id: gif_id)})
  end

  def gif=(val)
    write_association(:gif, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :gif_id).item
  end

  def build_gif(attributes={}, &block)
    association = classes('Gif').try(:new, attributes, &block)
    write_association(:gif, association) unless association.nil?
  end

  def create_gif(attributes={}, &block)
    association = classes('Gif').try(:create,attributes, &block)
    write_association(:gif, association) unless association.nil?
  end
  alias_method :create_gif!, :create_gif

  def team
    read_association(:team) || write_association(:team, classes('Team').try{ |k| k.find_by(id: team_id)})
  end

  def team=(val)
    write_association(:team, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :team_id).item
  end

  def build_team(attributes={}, &block)
    association = classes('Team').try(:new, attributes, &block)
    write_association(:team, association) unless association.nil?
  end

  def create_team(attributes={}, &block)
    association = classes('Team').try(:create,attributes, &block)
    write_association(:team, association) unless association.nil?
  end
  alias_method :create_team!, :create_team


  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include TeamgifMock::Scopes
  end

  private

  def self.new_relation(collection)
    TeamgifMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


  def upvote
    call_mock_method :upvote, Kernel.caller
  end

  def downvote
    call_mock_method :downvote, Kernel.caller
  end

end