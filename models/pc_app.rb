class PcApp < ActiveRecord::Base
  self.table_name = "pc_apps"
  
  belongs_to :pc_program, :foreign_key => 'program_code', :primary_key => 'code',:class_name => 'PcProgram'
  
  def disable!
    self.is_enabled = 'N'
    save!
  end
  
  def enable!
    self.is_enabled = 'Y'
    save!
  end
end