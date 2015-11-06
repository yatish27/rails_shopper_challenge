class ApplicantsController < ApplicationController
  before_action :authenticate, only: [:edit, :update, :show, :apply]
  before_action :logged_in?, only: [:new]

  def new
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(applicant_params)
    if @applicant.next_step
      log_in(@applicant)
      redirect_to apply_applicants_path
    else
      render :new
    end
  end

  # For a multi step creation process, every step will be rendered by apply and processed by next_step
  # Currently, we have only 2 steps, but like the real shoppers app multiple steps can be easily added
  def apply
  end

  def next_step
    current_applicant.assign_attributes(applicant_params)
    current_applicant.next_step
    redirect_to apply_applicants_path
  end

  def edit
  end

  def update
    if current_applicant.update(applicant_params)
      redirect_to apply_applicants_path
    else
      render :edit
    end
  end

  private

  def applicant_params
    params.require(:applicant).permit(:first_name, :last_name, :email,
                                      :phone, :phone_type,
                                      :region, :background_check_consent)
  end
end
