class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|

      t.string :space1, default: ' '
      t.string :space2, default: ' '
      t.string :space3, default: ' '
      t.string :space4, default: ' '
      t.string :space5, default: ' '
      t.string :space6, default: ' '
      t.string :space7, default: ' '
      t.string :space8, default: ' '
      t.string :space9, default: ' '
      t.string :player, default: 'HUMAN'

      t.timestamps
    end
  end
end
