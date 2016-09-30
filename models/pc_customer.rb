class PcCustomer < ActiveRecord::Base
  self.table_name = "pc_customers"
    
  def disable!
    self.cust_status = 'inactive'
    save!
  end
  
  def enable!
    self.cust_status = 'active'
    save!
  end
end