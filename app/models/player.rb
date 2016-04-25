class Player < ActiveRecord::Base
  has_one :score, dependent: :destroy
  has_many :matches, through: :player_matches
  has_many :player_matches
  validates_presence_of :name, message: 'Required'
  validates_presence_of :alias, message: 'Required'

  after_create do
    # generate score record
    self.build_score(player: self).save!
    puts "[SERVER] Generated new score record for player #{self.id}"
  end

  def self.inactive(player)
    player.active = false
    player.save
    player.score.destroy
  end
end


