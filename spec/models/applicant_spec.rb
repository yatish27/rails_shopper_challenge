require 'rails_helper'

describe Applicant do
  describe '.funnel_histogram' do
    let(:st_of_week) { DateTime.new(2014, 1, 1).beginning_of_week.utc }
    let(:end_of_week) { DateTime.new(2014, 1, 1).end_of_week.utc }
    let(:now) { DateTime.new(2014, 1, 1) }
    let(:one_week_later) { now + 1.week }
    let(:key) { "#{st_of_week.strftime("%Y-%m-%d")}-#{end_of_week.strftime("%Y-%m-%d")}" }
    let(:expected_hash)  { Hash.new }

    context 'with no applicants' do
      it 'returns a empty hash' do
        expect(Applicant.funnel_histogram(start_date: st_of_week, end_date: end_of_week)).to eq(expected_hash)
      end
    end

    context 'with applicant created for current week' do
      before do
        Applicant::WORKFLOW_STATES.each do |state|
          FactoryGirl.create(:applicant, workflow_state: state, created_at: now)
        end
        expected_hash[key] = {}
        Applicant::WORKFLOW_STATES.each do |state|
          expected_hash[key][state] = 1
        end
      end

      it "returns a hash for weekly count of applicant's status" do
        expect(Applicant.funnel_histogram(start_date: st_of_week, end_date: end_of_week)).to eq(expected_hash)
      end
    end

    context "with applicants created on start and end of the week" do
      before do
        Applicant::WORKFLOW_STATES.each do |state|
          FactoryGirl.create(:applicant, workflow_state: state, created_at: st_of_week.beginning_of_day)
          FactoryGirl.create(:applicant, workflow_state: state, created_at: end_of_week)
        end
        expected_hash[key] = {}
        Applicant::WORKFLOW_STATES.each do |state|
          expected_hash[key][state] = 2
        end
      end

      it "returns a hash for weekly count of applicants' status including applicants created on Monday and Sunday" do
        expect(Applicant.funnel_histogram(start_date: st_of_week, end_date: end_of_week)).to eq(expected_hash)
      end
    end

    context "with applicants created in multiple week ranges" do
      before do
        Applicant::WORKFLOW_STATES.each do |state|
          FactoryGirl.create(:applicant, workflow_state: state, created_at: now)
          FactoryGirl.create(:applicant, workflow_state: state, created_at: one_week_later)
        end
        week_2_start = one_week_later.beginning_of_week.strftime("%Y-%m-%d")
        week_2_end = one_week_later.end_of_week.strftime("%Y-%m-%d")
        key_2 = "#{week_2_start}-#{week_2_end}"

        expected_hash[key] = {}
        expected_hash[key_2] = {}

        Applicant::WORKFLOW_STATES.each do |state|
          expected_hash[key][state] = 1
          expected_hash[key_2][state] = 1
        end
      end

      it "returns a hash for weekly count of applicants" do
        expect(Applicant.funnel_histogram(start_date: st_of_week, end_date: one_week_later.end_of_week)).to eq(expected_hash)
      end
    end
  end
end