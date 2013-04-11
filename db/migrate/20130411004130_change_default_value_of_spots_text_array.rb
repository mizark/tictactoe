class ChangeDefaultValueOfSpotsTextArray < ActiveRecord::Migration
  def up
  	change_column :boards, :spots, :text, default: '         '
  end

  def down
  end
end
