class AddStateToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :state, :string
  end
end
