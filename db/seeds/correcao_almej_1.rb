User.all.each do |user|
  password = Devise.friendly_token.first(8)
  user.password = password
  user.password_confirmation = password
  user.save

  UserMailer.welcome(user, password).deliver
end
