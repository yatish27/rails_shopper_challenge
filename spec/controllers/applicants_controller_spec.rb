require 'rails_helper'

describe ApplicantsController do
  describe '#create' do
    let(:applicant_attributes) { FactoryGirl.attributes_for(:applicant) }
    context 'when valid' do
      before do
        post :create, applicant: applicant_attributes
      end

      it 'creates a new applicant' do
        expect(Applicant.last.first_name).to eq(applicant_attributes[:first_name])
      end

      it "applicant's state is background_check" do
        expect(assigns(:applicant).state).to eq('background_check')
      end
    end
  end
end