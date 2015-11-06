class FunnelsController < ApplicationController
  def index
    @funnel = Applicant.funnel_histogram(start_date: start_date, end_date: end_date)

    respond_to do |format|
      format.html { @chart_funnel = formatted_funnel }
      format.json { render json: @funnel }
    end
  end

  private

  # generates a formatted version of the funnel for display in d3
  def formatted_funnel
    formatted = Hash.new { |h, k| h[k] = [] }

    @funnel.each do |date, state_counts|
      state_counts.each do |state, count|
        formatted[state] << {label: date, value: count}
      end
    end

    formatted.map do |k, v|
      {
        key: k.humanize,
        values: v
      }
    end
  end

  # By default sets the start date as the start of the current month.
  def start_date
    params[:start_date] ? params[:start_date].to_datetime : DateTime.now.beginning_of_month
  end

  def end_date
    params[:end_date] ? params[:end_date].to_datetime : DateTime.now
  end
end
