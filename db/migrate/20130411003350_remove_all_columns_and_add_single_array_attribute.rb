class RemoveAllColumnsAndAddSingleArrayAttribute < ActiveRecord::Migration
  def up
  	add_column :boards, :spots, :text
  	remove_column :boards, [:space1, :space2, :space3, :space4, :space5, :space6, :space7, :space8, :space9]
  end

  def down
  end
end
