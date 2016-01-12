class Payment < ActiveRecord::Base
  validates :method,
            inclusion: { in: %w(PagSeguro Boleto Dinheiro) }

  belongs_to :user

  def set_payment(user)
    @user = user
    set_price
  end

  private  
    def set_price 
      if @user.payment_method == "Boleto"
        set_billet_INFO
      elsif @user.payment_method == "PagSeguro"
        set_price_pagseguro
      end    
    end

    def set_price_pagseguro
      case @user.lot.number
      when 1
        self.price = 401.42
      when 2
        self.price = 411.84
      when 3
        self.price = 422.25
      end
    end

    def set_billet_INFO
      case self.portions
      when 1
        if @user.if_fed?
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_1_1_FED
            self.price = BILLET_1_PRICE_1_FED
          when 2
            self.link_1 = BILLET_2_LINK_1_1_FED
            self.price = BILLET_2_PRICE_1_FED
          when 3            
            self.link_1 = BILLET_2_LINK_1_1_FED
            self.price = BILLET_2_PRICE_1_FED
          end
        else
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_1_1_UNFED
            self.price = BILLET_1_PRICE_1_UNFED
          when 2
            self.link_1 = BILLET_2_LINK_1_1_UNFED
            self.price = BILLET_2_PRICE_1_UNFED
          when 3            
            self.link_1 = BILLET_2_LINK_1_1_UNFED
            self.price = BILLET_2_PRICE_1_UNFED
          end
        end
      when 2
        if @user.if_fed?
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_2_1_FED
            self.link_2 = BILLET_1_LINK_2_2_FED
            self.price = BILLET_1_PRICE_2_FED
          when 2
            self.link_1 = BILLET_2_LINK_2_1_FED
            self.link_2 = BILLET_2_LINK_2_2_FED
            self.price = BILLET_2_PRICE_2_FED
          when 3            
            self.link_1 = BILLET_3_LINK_2_1_FED
            self.link_2 = BILLET_3_LINK_1_1_FED
            self.price = BILLET_3_PRICE_1_FED
          end
        else
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_2_1_UNFED
            self.link_2 = BILLET_1_LINK_2_2_UNFED
            self.price = BILLET_1_PRICE_2_UNFED
          when 2
            self.link_1 = BILLET_2_LINK_2_1_UNFED
            self.link_2 = BILLET_2_LINK_2_2_UNFED
            self.price = BILLET_2_PRICE_2_UNFED
          when 3            
            self.link_1 = BILLET_3_LINK_2_1_UNFED
            self.link_2 = BILLET_3_LINK_1_1_UNFED
            self.price = BILLET_3_PRICE_1_UNFED
          end
        end
      when 3
        if @user.if_fed?
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_3_1_FED
            self.link_2 = BILLET_1_LINK_3_2_FED
            self.link_3 = BILLET_1_LINK_3_3_FED
            self.price = BILLET_1_PRICE_3_FED
          when 2
            self.link_1 = BILLET_2_LINK_3_1_FED
            self.link_2 = BILLET_2_LINK_3_2_FED
            self.link_3 = BILLET_2_LINK_3_3_FED
            self.price = BILLET_2_PRICE_2_FED
          when 3            
            self.link_1 = BILLET_3_LINK_3_1_FED
            self.link_2 = BILLET_3_LINK_3_2_FED
            self.link_3 = BILLET_3_LINK_3_3_FED
            self.price = BILLET_3_PRICE_1_FED
          end
        else
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_3_1_UNFED
            self.link_2 = BILLET_1_LINK_3_2_UNFED
            self.link_3 = BILLET_1_LINK_3_3_UNFED
            self.price = BILLET_1_PRICE_3_UNFED
          when 2
            self.link_1 = BILLET_2_LINK_3_1_UNFED
            self.link_2 = BILLET_2_LINK_3_2_UNFED
            self.link_3 = BILLET_2_LINK_3_3_UNFED
            self.price = BILLET_2_PRICE_2_UNFED
          when 3            
            self.link_1 = BILLET_3_LINK_3_1_UNFED
            self.link_2 = BILLET_3_LINK_3_2_UNFED
            self.link_3 = BILLET_3_LINK_3_3_UNFED
            self.price = BILLET_3_PRICE_1_UNFED
          end
        end
      when 4 
      if @user.if_fed?
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_4_1_FED
            self.link_2 = BILLET_1_LINK_4_2_FED
            self.link_3 = BILLET_1_LINK_4_3_FED
            self.link_4 = BILLET_1_LINK_4_4_FED
            self.price = BILLET_1_PRICE_4_FED
          when 2
            self.link_1 = BILLET_2_LINK_4_1_FED
            self.link_2 = BILLET_2_LINK_4_2_FED
            self.link_3 = BILLET_2_LINK_4_3_FED
            self.link_4 = BILLET_2_LINK_4_4_FED
            self.price = BILLET_2_PRICE_4_FED
          when 3            
            self.link_1 = BILLET_3_LINK_4_1_FED
            self.link_2 = BILLET_3_LINK_4_2_FED
            self.link_3 = BILLET_3_LINK_4_3_FED
            self.link_4 = BILLET_3_LINK_4_4_FED
            self.price = BILLET_3_PRICE_4_FED
          end
        else
          case @user.lot.number
          when 1
            self.link_1 = BILLET_1_LINK_3_1_UNFED
            self.link_2 = BILLET_1_LINK_3_2_UNFED
            self.link_3 = BILLET_1_LINK_3_3_UNFED
            self.price = BILLET_1_PRICE_3_UNFED
          when 2
            self.link_1 = BILLET_2_LINK_3_1_UNFED
            self.link_2 = BILLET_2_LINK_3_2_UNFED
            self.link_3 = BILLET_2_LINK_3_3_UNFED
            self.price = BILLET_2_PRICE_2_UNFED
          when 3            
            self.link_1 = BILLET_3_LINK_3_1_UNFED
            self.link_2 = BILLET_3_LINK_3_2_UNFED
            self.link_3 = BILLET_3_LINK_3_3_UNFED
            self.price = BILLET_3_PRICE_1_UNFED
          end
        end     
      end
    end
end
