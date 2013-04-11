class Board < ActiveRecord::Base
  attr_accessible :spots

  serialize :spots

  def self.winning_combos
  	[[0,1,2], [3,4,5], [6,7,8], [0,4,8], [2,4,6], [0,3,6], [1,4,7], [2,5,8]]
  end
  	
  def self.side_spots
  	[1,3,5,7]
  end

  def self.corner_spots
  	[0,2,6,8]
  end

  def self.opposite_corners
  	{0=>8, 2=>6, 8=>0, 6=>2}
  end

  def self.fork_combos
  	[[3,0,1], [1,2,5], [5,8,7], [3,6,7], [1,4,3], [1,4,5], [3,4,7], [5,4,8]]
  end

end
