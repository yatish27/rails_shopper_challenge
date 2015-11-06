module ApplicationHelper
  def log_in(applicant)
    session[:applicant_id] = applicant.id
    @current_applicant = applicant
  end

  def logout
    session.delete(:applicant_id)
  end

  def current_applicant
    @current_applicant ||= Applicant.find_by(id: session[:applicant_id])
  end

  def signed_in?
    current_applicant.present?
  end
end
