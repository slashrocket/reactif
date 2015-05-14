class Teamgif < ActiveRecord::Base
  belongs_to :gif
  belongs_to :team
  after_initialize :assign_defaults_on_new_teamgif, if: 'new_record?'
  
  
  private
  
  def assign_defaults_on_new_teamgif
    self.votes = 25
    self.save!
  end
end
