require 'active_mocker/mock'

class TeamMock < ActiveMocker::Mock::Base
  created_with('1.8.3')

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "name"=>nil, "created_at"=>nil, "updated_at"=>nil, "user_id"=>nil, "domain"=>nil, "webhook"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, name: String, created_at: DateTime, updated_at: DateTime, user_id: Fixnum, domain: String, webhook: String }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:user=>nil, :teamgifs=>nil, :gifs=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"User"=>{:belongs_to=>[:user]}, "Teamgif"=>{:has_many=>[:teamgifs]}, "Gif"=>{:has_many=>[:gifs]}}.merge(super)
    end

    def mocked_class
      "Team"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "name", "created_at", "updated_at", "user_id", "domain", "webhook"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "teams" || super
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

  def name
    read_attribute(:name)
  end

  def name=(val)
    write_attribute(:name, val)
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

  def user_id
    read_attribute(:user_id)
  end

  def user_id=(val)
    write_attribute(:user_id, val)
  end

  def domain
    read_attribute(:domain)
  end

  def domain=(val)
    write_attribute(:domain, val)
  end

  def webhook
    read_attribute(:webhook)
  end

  def webhook=(val)
    write_attribute(:webhook, val)
  end

  ##################################
  #         Associations           #
  ##################################

# belongs_to
  def user
    read_association(:user) || write_association(:user, classes('User').try{ |k| k.find_by(id: user_id)})
  end

  def user=(val)
    write_association(:user, val)
    ActiveMocker::Mock::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
  end

  def build_user(attributes={}, &block)
    association = classes('User').try(:new, attributes, &block)
    write_association(:user, association) unless association.nil?
  end

  def create_user(attributes={}, &block)
    association = classes('User').try(:create,attributes, &block)
    write_association(:user, association) unless association.nil?
  end
  alias_method :create_user!, :create_user

# has_many
  def teamgifs
    read_association(:teamgifs, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'team_id', foreign_id: self.id, relation_class: classes('Teamgif'), source: '') })
  end

  def teamgifs=(val)
    write_association(:teamgifs, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'team_id', foreign_id: self.id, relation_class: classes('Teamgif'), source: ''))
  end

  def gifs
    read_association(:gifs, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'gif_id', foreign_id: self.id, relation_class: classes('Gif'), source: '') })
  end

  def gifs=(val)
    write_association(:gifs, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'gif_id', foreign_id: self.id, relation_class: classes('Gif'), source: ''))
  end

  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include TeamMock::Scopes
  end

  private

  def self.new_relation(collection)
    TeamMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


end