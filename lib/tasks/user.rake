namespace :user do
  desc "TODO"
  task set_all_incomplete: :environment do
    User.all.each do |user|
      user.update_attribute :lot_id, nil
    end
  end

end
