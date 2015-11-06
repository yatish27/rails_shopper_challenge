class SessionsController < ApplicationController
  layout "home"
  def new
  end

  def create
    applicant = Applicant.find_by(email: params[:email])
    if applicant
      log_in(applicant)
      redirect_to apply_applicants_path
    else
      flash[:error] = "Invalid email"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end