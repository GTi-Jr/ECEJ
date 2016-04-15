class AddDescriptionAndFacilitatorImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text
    add_column :events, :facilitator_image, :string
  end
end
