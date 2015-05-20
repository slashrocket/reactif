require 'active_mocker/mock'

class GifMock < ActiveMocker::Mock::Base
  created_with('1.8.3')
  prepend ReactionGIFS

  class << self

    def attributes
      @attributes ||= HashWithIndifferentAccess.new({"id"=>nil, "word"=>nil, "url"=>nil, "created_at"=>nil, "updated_at"=>nil}).merge(super)
    end

    def types
      @types ||= ActiveMocker::Mock::HashProcess.new({ id: Fixnum, word: String, url: String, created_at: DateTime, updated_at: DateTime }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= {:teams=>nil, :teamgifs=>nil}.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= {"Team"=>{:has_many=>[:teams]}, "Teamgif"=>{:has_many=>[:teamgifs]}}.merge(super)
    end

    def mocked_class
      "Gif"
    end

    private :mocked_class

    def attribute_names
      @attribute_names ||= ["id", "word", "url", "created_at", "updated_at"] | super
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "gifs" || super
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

  def word
    read_attribute(:word)
  end

  def word=(val)
    write_attribute(:word, val)
  end

  def url
    read_attribute(:url)
  end

  def url=(val)
    write_attribute(:url, val)
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


# has_many
  def teams
    read_association(:teams, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'gif_id', foreign_id: self.id, relation_class: classes('Team'), source: '') })
  end

  def teams=(val)
    write_association(:teams, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'gif_id', foreign_id: self.id, relation_class: classes('Team'), source: ''))
  end

  def teamgifs
    read_association(:teamgifs, -> { ActiveMocker::Mock::HasMany.new([],foreign_key: 'gif_id', foreign_id: self.id, relation_class: classes('Teamgif'), source: '') })
  end

  def teamgifs=(val)
    write_association(:teamgifs, ActiveMocker::Mock::HasMany.new(val, foreign_key: 'gif_id', foreign_id: self.id, relation_class: classes('Teamgif'), source: ''))
  end

  module Scopes
    include ActiveMocker::Mock::Base::Scopes

  end

  extend Scopes

  class ScopeRelation < ActiveMocker::Mock::Association
    include GifMock::Scopes
  end

  private

  def self.new_relation(collection)
    GifMock::ScopeRelation.new(collection)
  end

  public

  ##################################
  #        Model Methods           #
  ##################################


  def self.getgifs(search_query)
    call_mock_method :getgifs, Kernel.caller, search_query
  end

  def self.encode_query(search_query)
    call_mock_method :encode_query, Kernel.caller, search_query
  end

  def self.save_gifs(search_query)
    call_mock_method :save_gifs, Kernel.caller, search_query
  end

  def self.gif_links
    call_mock_method :gif_links, Kernel.caller
  end

end