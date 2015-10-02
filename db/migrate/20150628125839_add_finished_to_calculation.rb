class AddFinishedToCalculation < ActiveRecord::Migration
  def change
    add_column :calculations, :finished, :boolean, default: false
  end
end
