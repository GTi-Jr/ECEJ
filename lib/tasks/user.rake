namespace :user do
  desc "TODO"
  task set_all_incomplete: :environment do
    User.all.each do |user|
      user.update_attribute :lot_id, nil
    end
  end

  task set_users_state: :environment do
    progress = 1
    total = User.all.count
    User.all.each do |user|
      p "#{progress}/#{total}"
      if !user.cep.nil?
        user.update_attribute :state, BuscaEndereco.cep(user.cep)[:uf]
      else
        p "     CEP do usuário #{user.email} é inválido."
      end
      progress += 1
    end
  end

end
