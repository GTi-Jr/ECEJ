namespace :user do
  desc "TODO"
  task set_all_incomplete: :environment do
    User.all.each do |user|
      user.update_attribute :lot_id, nil
    end
  end

  task set_users_address: :environment do
    progress = 1
    total = User.all.count
    User.all.each do |user|
      p "#{progress}/#{total}"
      if !user.cep.blank?
        if !user.cep1.nil?
          begin
            if get_cep = BuscaEndereco.cep(user.cep1)
              user.update_attributes cep: user.cep, state: get_cep[:uf], city: get_cep[:cidade], street: get_cep[:logradouro]
            end
          rescue
          end
        else
          p "     CEP do usuário #{user.email} é inválido."
        end
      end
      progress += 1
    end
  end

  task set_billets_links: :environment do
    Payment.where(link_1: "LINK").each do |payment|
      portions = payment.portions
      method = payment.method
      p "portions #{portions}"
      p "method #{method}"

      payment.change_method method, portions if !payment.user.nil? && !payment.user.lot.nil?

      p "AFTER"
      p "portions #{portions}"
      p "method #{method}"
      payment.save
    end
  end

  task remember_lot_1_2_payment: :environment do
    users = User.select { |user| !user.payment.nil? && !user.payment.partially_paid? }
    counter = 0;
    users.each do |user|
      UsersLotMailer.remember_lot_1_2_payment(user).deliver_now
      p "Email sent to #{user.email}"
      counter += 1
    end
    p "#{counter} EMAILS SENT TO REMEMBER PAYMENT"
  end

  task remember_lot_1_2_payment_complement: :environment do
    users = User.select do |user|
      !user.lot.nil? && user.payment.nil?
    end
    emails = []

    users.each do |user|
      UsersLotMailer.remember_lot_1_2_payment(user).deliver_now
      puts "Email sent to #{user.email}"
      emails << user.email
    end

    emails.each { |email| puts email }
    puts "#{emails.length} EMAILS SENT TO REMEMBER PAYMENT"
  end

  task waiting_list_into_lot_2: :environment do
    second_lot = Lot.second
    waiting_list = User.eligible
    emails = []

    waiting_list.each do |user|
      user.insert_into_lot(second_lot)
      emails << user.email
      UsersLotMailer.waiting_list_into_lot_2(user).deliver_now
    end

    emails.each { |email| puts email }
    puts "EMAILS SENT: #{emails.length}"

  end

end
