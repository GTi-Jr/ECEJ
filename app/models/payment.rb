class Payment < ActiveRecord::Base
  #require "#{Rails.root}/config/initializers/payment_module.rb"

  validates :method,
            inclusion: { in: %w(PagSeguro Boleto Dinheiro) }

  belongs_to :user

  def set_payment
    set_price
    self.save
  end

  def pagseguro?
    self.method == "PagSeguro"
  end

  def boleto?
    self.method == "Boleto"
  end

  def money?
    self.method == "Dinheiro"
  end

  def total_amount
    self.price * self.portions
  end

  def amount_paid
    self.price * self.portion_paid
  end

  def partially_paid?
    self.portion_paid > 0 ? true : false
  end

  def paid?
    self.portion_paid == self.portions
  end

  def money_amount
    case self.user.lot
    when 1
      if self.user.is_fed?
        PaymentModule::MONEY_PRICE_1_FED
      else
        PaymentModule::MONEY_PRICE_1_UNFED
      end
    when 2
      if self.user.is_fed?
        PaymentModule::MONEY_PRICE_2_FED
      else
        PaymentModule::MONEY_PRICE_2_UNFED
      end
    when 3
      if self.user.is_fed?
        PaymentModule::MONEY_PRICE_3_FED
      else
        PaymentModule::MONEY_PRICE_3_UNFED
      end
    end
  end

  def billets_links
    billet_links = Array.new
    if self.method == "Boleto"
      billet_links << self.link_1 unless self.link_1.nil?
      billet_links << self.link_2 unless self.link_2.nil?
      billet_links << self.link_3 unless self.link_3.nil?
      billet_links << self.link_4 unless self.link_4.nil?
    end
    billet_links
  end



  def set_price
    if self.method == "Boleto"
      self.set_billet_INFO
    elsif self.method == "PagSeguro"
      self.set_price_pagseguro
    end
  end

  def set_price_pagseguro
    case self.user.lot.number
    when 1
      self.price = 401.42
    when 2
      self.price = 411.84
    when 3
      self.price = 422.25
    end
  end

  def set_billet_INFO
    Rails.logger.info "\n portions: #{self.portions}"
    Rails.logger.info "\n lot number: #{self.user.lot.number}"
    Rails.logger.info "\n User is fed?: #{self.user.is_fed?.to_s}"
    case self.portions
    when 1
      if self.user.is_fed?
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_1_1_FED
          self.price = PaymentModule::BILLET_1_PRICE_1_FED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_1_1_FED
          self.price = PaymentModule::BILLET_2_PRICE_1_FED
        when 3
          self.link_1 = PaymentModule::BILLET_2_LINK_1_1_FED
          self.price = PaymentModule::BILLET_2_PRICE_1_FED
        end
      else
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_1_1_UNFED
          self.price = PaymentModule::BILLET_1_PRICE_1_UNFED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_1_1_UNFED
          self.price = PaymentModule::BILLET_2_PRICE_1_UNFED
        when 3
          self.link_1 = PaymentModule::BILLET_2_LINK_1_1_UNFED
          self.price = PaymentModule::BILLET_2_PRICE_1_UNFED
        end
      end
    when 2
      if self.user.is_fed?
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_2_1_FED
          self.link_2 = PaymentModule::BILLET_1_LINK_2_2_FED
          self.price = PaymentModule::BILLET_1_PRICE_2_FED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_2_1_FED
          self.link_2 = PaymentModule::BILLET_2_LINK_2_2_FED
          self.price = PaymentModule::BILLET_2_PRICE_2_FED
        when 3
          self.link_1 = PaymentModule::BILLET_3_LINK_2_1_FED
          self.link_2 = PaymentModule::BILLET_3_LINK_1_1_FED
          self.price = PaymentModule::BILLET_3_PRICE_1_FED
        end
      else
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_2_1_UNFED
          self.link_2 = PaymentModule::BILLET_1_LINK_2_2_UNFED
          self.price = PaymentModule::BILLET_1_PRICE_2_UNFED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_2_1_UNFED
          self.link_2 = PaymentModule::BILLET_2_LINK_2_2_UNFED
          self.price = PaymentModule::BILLET_2_PRICE_2_UNFED
        when 3
          self.link_1 = PaymentModule::BILLET_3_LINK_2_1_UNFED
          self.link_2 = PaymentModule::BILLET_3_LINK_1_1_UNFED
          self.price = PaymentModule::BILLET_3_PRICE_1_UNFED
        end
      end
    when 3
      if self.user.is_fed?
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_3_1_FED
          self.link_2 = PaymentModule::BILLET_1_LINK_3_2_FED
          self.link_3 = PaymentModule::BILLET_1_LINK_3_3_FED
          self.price = PaymentModule::BILLET_1_PRICE_3_FED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_3_1_FED
          self.link_2 = PaymentModule::BILLET_2_LINK_3_2_FED
          self.link_3 = PaymentModule::BILLET_2_LINK_3_3_FED
          self.price = PaymentModule::BILLET_2_PRICE_2_FED
        when 3
          self.link_1 = PaymentModule::BILLET_3_LINK_3_1_FED
          self.link_2 = PaymentModule::BILLET_3_LINK_3_2_FED
          self.link_3 = PaymentModule::BILLET_3_LINK_3_3_FED
          self.price = PaymentModule::BILLET_3_PRICE_1_FED
        end
      else
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_3_1_UNFED
          self.link_2 = PaymentModule::BILLET_1_LINK_3_2_UNFED
          self.link_3 = PaymentModule::BILLET_1_LINK_3_3_UNFED
          self.price = PaymentModule::BILLET_1_PRICE_3_UNFED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_3_1_UNFED
          self.link_2 = PaymentModule::BILLET_2_LINK_3_2_UNFED
          self.link_3 = PaymentModule::BILLET_2_LINK_3_3_UNFED
          self.price = PaymentModule::BILLET_2_PRICE_2_UNFED
        when 3
          self.link_1 = PaymentModule::BILLET_3_LINK_3_1_UNFED
          self.link_2 = PaymentModule::BILLET_3_LINK_3_2_UNFED
          self.link_3 = PaymentModule::BILLET_3_LINK_3_3_UNFED
          self.price = PaymentModule::BILLET_3_PRICE_1_UNFED
        end
      end
    when 4
      if self.user.is_fed?
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_4_1_FED
          self.link_2 = PaymentModule::BILLET_1_LINK_4_2_FED
          self.link_3 = PaymentModule::BILLET_1_LINK_4_3_FED
          self.link_4 = PaymentModule::BILLET_1_LINK_4_4_FED
          self.price = PaymentModule::BILLET_1_PRICE_4_FED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_4_1_FED
          self.link_2 = PaymentModule::BILLET_2_LINK_4_2_FED
          self.link_3 = PaymentModule::BILLET_2_LINK_4_3_FED
          self.link_4 = PaymentModule::BILLET_2_LINK_4_4_FED
          self.price = PaymentModule::BILLET_2_PRICE_4_FED
        when 3
          self.link_1 = PaymentModule::BILLET_3_LINK_4_1_FED
          self.link_2 = PaymentModule::BILLET_3_LINK_4_2_FED
          self.link_3 = PaymentModule::BILLET_3_LINK_4_3_FED
          self.link_4 = PaymentModule::BILLET_3_LINK_4_4_FED
          self.price = PaymentModule::BILLET_3_PRICE_4_FED
        end
      else
        case self.user.lot.number
        when 1
          self.link_1 = PaymentModule::BILLET_1_LINK_4_1_UNFED
          self.link_2 = PaymentModule::BILLET_1_LINK_4_2_UNFED
          self.link_3 = PaymentModule::BILLET_1_LINK_4_3_UNFED
          self.link_4 = PaymentModule::BILLET_1_LINK_4_4_UNFED
          self.price = PaymentModule::BILLET_1_PRICE_4_UNFED
        when 2
          self.link_1 = PaymentModule::BILLET_2_LINK_4_1_UNFED
          self.link_2 = PaymentModule::BILLET_2_LINK_4_2_UNFED
          self.link_3 = PaymentModule::BILLET_2_LINK_4_3_UNFED
          self.link_4 = PaymentModule::BILLET_2_LINK_4_4_UNFED
          self.price = PaymentModule::BILLET_2_PRICE_4_UNFED
        when 3
          self.link_1 = PaymentModule::BILLET_3_LINK_4_1_UNFED
          self.link_2 = PaymentModule::BILLET_3_LINK_4_2_UNFED
          self.link_3 = PaymentModule::BILLET_3_LINK_4_3_UNFED
          self.link_4 = PaymentModule::BILLET_3_LINK_4_4_UNFED
          self.price = PaymentModule::BILLET_3_PRICE_4_UNFED
        end
      end
    end
  end
end
