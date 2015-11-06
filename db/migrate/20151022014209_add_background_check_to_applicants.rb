class AddBackgroundCheckToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :background_check_consent, :boolean, null: false, default: false
  end
end
