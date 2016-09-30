class PcProgram < ActiveRecord::Base
  after_initialize :defaults, unless: :persisted?
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
  
  private
  def defaults
    self.is_enabled = 'Y'
    self.approval_status = 'A'
    self.lock_version = 0
    self.last_action = 'C'
  end
  
end