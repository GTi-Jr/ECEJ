class AddDescriptionAndFacilitatorImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text, default: ''
    add_column :events, :facilitator_image, :string
  end
end
