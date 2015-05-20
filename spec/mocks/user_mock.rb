require 'active_mocker/mock'

class UserMock < ActiveMocker::Mock::Base
  created_with('1.8.3')

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "email"=>"", "encrypted_password"=>"", "reset_password_token"=>nil, "reset_password_sent_at"=>nil, "remember_created_at"=>nil, "sign_in_count"=>0, "current_sign_in_at"=>nil, "last_sign_in_at"=>nil, "current_sign_in_ip"=>nil, "last_sign_in_ip"=>nil, "created_at"=>nil, "updated_at"=>nil, "name"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, email: String, encrypted_password: String, reset_password_token: String, reset_password_sent_at: DateTime, remember_created_at: DateTime, sign_in_count: Fixnum, current_sign_in_at: DateTime, last_sign_in_at: DateTime, current_sign_in_ip: String, last_sign_in_ip: String, created_at: DateTime, updated_at: DateTime, name: String }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:teams=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"Team"=>{:has_many=>[:teams]}}.merge(super)
    end

    def mocked_class
      "User"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "email", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip", "created_at", "updated_at", "name"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "users" || super
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

  def email
    read_attribute(:email)
  end

  def email=(val)
    write_attribute(:email, val)
  end

  def encrypted_password
    read_attribute(:encrypted_password)
  end

  def encrypted_password=(val)
    write_attribute(:encrypted_password, val)
  end

  def reset_password_token
    read_attribute(:reset_password_token)
  end

  def reset_password_token=(val)
    write_attribute(:reset_password_token, val)
  end

  def reset_password_sent_at
    read_attribute(:reset_password_sent_at)
  end

  def reset_password_sent_at=(val)
    write_attribute(:reset_password_sent_at, val)
  end

  def remember_created_at
    read_attribute(:remember_created_at)
  end

  def remember_created_at=(val)
    write_attribute(:remember_created_at, val)
  end

  def sign_in_count
    read_attribute(:sign_in_count)
  end

  def sign_in_count=(val)
    write_attribute(:sign_in_count, val)
  end

  def current_sign_in_at
    read_attribute(:current_sign_in_at)
  end

  def current_sign_in_at=(val)
    write_attribute(:current_sign_in_at, val)
  end

  def last_sign_in_at
    read_attribute(:last_sign_in_at)
  end

  def last_sign_in_at=(val)
    write_attribute(:last_sign_in_at, val)
  end

  def current_sign_in_ip
    read_attribute(:current_sign_in_ip)
  end

  def current_sign_in_ip=(val)
    write_attribute(:current_sign_in_ip, val)
  end

  def last_sign_in_ip
    read_attribute(:last_sign_in_ip)
  end

  def last_sign_in_ip=(val)
    write_attribute(:last_sign_in_ip, val)
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

  def name
    read_attribute(:name)
  end

  def name=(val)
    write_attribute(:name, val)
  end

  ##################################
  #         Associations           #
  ##################################


# has_many
  def teams
    read_association(:teams, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Team'), source: '') })
  end

  def teams=(val)
    write_association(:teams, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'user_id', foreign_id: self.id, relation_class: classes('Team'), source: ''))
  end

  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include UserMock::Scopes
  end

  private

  def self.new_relation(collection)
    UserMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


  def slug
    call_mock_method :slug, Kernel.caller
  end

  def to_param
    call_mock_method :to_param, Kernel.caller
  end

end