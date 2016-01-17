class Payment < ActiveRecord::Base
  validates :method,
            inclusion: { in: %w(PagSeguro Boleto Dinheiro) }
  validates :portions,
            numericality: { less_than_or_equal_to: 4,
                            greater_than: 0 }
  validates :portion_paid,
            numericality: { greater_than_or_equal_to: 0 }
  validate :portion_paid_smaller_than_portions

  belongs_to :user

  def set_payment
    set_price
    self.save
  end

  def pagseguro?
    method == "PagSeguro"
  end

  def boleto?
    method == "Boleto"
  end

  def money?
    method == "Dinheiro"
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

  def change_method(method, portions = 1)
    case method.to_s.humanize.downcase
    when "pagseguro"
      self.method = "PagSeguro"
      self.portions = 1
    when "boleto"
      self.method = "Boleto"
      self.portions = portions
    when "dinheiro"
      self.method = "Dinheiro"
      self.portions = 1
    end
    set_payment
  end

  def change_status(status)
    case status.to_s.humanize.downcase
    when 'paid'
      self.portion_paid = self.portion
    when 'non paid'
      self.portion_paid = 0
    end
    save
  end

  def set_billet_portion_paid(portion)
    if self.method == "Boleto"
      self.portion_paid = portion
    end
    save
  end

  private
  def set_price
    if method == "Boleto"
      set_billet_info false # clears the links
      set_billet_info # fill the links
    elsif method == "PagSeguro"
      set_price_pagseguro
      set_billet_info false
    elsif method == "Dinheiro"
      set_price_money
      set_billet_info false
    end
  end

  def set_price_pagseguro
    if user.is_fed?
      case self.user.lot.number
      when 1
        self.price = PaymentModule::PAGSEGURO_PRICE_1_FED
      when 2
        self.price = PaymentModule::PAGSEGURO_PRICE_2_FED
      when 3
        self.price = PaymentModule::PAGSEGURO_PRICE_3_FED
      end
    else
      case user.lot.number
      when 1
        self.price = PaymentModule::PAGSEGURO_PRICE_1_UNFED
      when 2
        self.price = PaymentModule::PAGSEGURO_PRICE_2_UNFED
      when 3
        self.price = PaymentModule::PAGSEGURO_PRICE_3_UNFED
      end
    end
  end

  def set_price_money
    if user.is_fed?
      case user.lot
      when 1
        self.price = PaymentModule::MONEY_PRICE_1_FED
      when 2
        self.price = PaymentModule::MONEY_PRICE_2_FED
      when 3
        self.price = PaymentModule::MONEY_PRICE_3_FED
      end
    else
      case user.lot
      when 1
        self.price = PaymentModule::MONEY_PRICE_1_UNFED
      when 2
        self.price = PaymentModule::MONEY_PRICE_2_UNFED
      when 3
        self.price = PaymentModule::MONEY_PRICE_3_UNFED
      end
    end
  end

  def set_billet_info(set_billets = true)
    unless set_billets
      self.link_1 = self.link_2 = self.link_3 = self.link_4 = nil
    else
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
  end # end :set_billet_info


  # VALIDATORS
  def portion_paid_smaller_than_portions
    errors.add(:portion_paid, "deve ser menor que a quatidade total de parcelas.") if portion_paid > portions
  end
end
