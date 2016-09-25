class PcProgram < ActiveRecord::Base
  self.table_name = "pc_programs"

  has_many :pc_products, :foreign_key => 'program_code', :primary_key => 'code', :class_name => 'PcProduct'
  
  def disable!
    self.is_enabled = 'N'
    save!
  end
  
  def enable!
    self.is_enabled = 'Y'
    save!
  end
end