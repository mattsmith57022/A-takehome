require 'rails_helper'

RSpec.describe "/polls", type: :request do

  let(:valid_attributes) {
    { name: 'Employee of the Year' }
  }

  let(:invalid_attributes) {
    { bad_params: 'no'}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Poll.create! valid_attributes
      get polls_url
      expect(response).to be_successful
      body = JSON.parse(response.body)
      expect(body["data"].first["name"]).to eq(valid_attributes[:name])
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      poll = Poll.create! valid_attributes
      get poll_url(poll)
      expect(response).to be_successful
      body = JSON.parse(response.body)
      expect(body["data"]["name"]).to eq(valid_attributes[:name])
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Poll" do
        expect {
          post polls_url, params: { poll: valid_attributes, format: :json }
        }.to change(Poll, :count).by(1)
        expect(response.status).to eq(200)
        response_json = JSON.parse(response.body)
        expect(response_json["data"]["name"]).to eq(valid_attributes[:name])
      end

    end

    context "with invalid parameters" do
      it "does not create a new Poll" do
        expect {
          post polls_url, params: { poll: invalid_attributes, format: :json }
        }.to change(Poll, :count).by(0)
      end


      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post polls_url, params: { poll: invalid_attributes, format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested poll" do
        poll = Poll.create! valid_attributes
        patch poll_url(poll), params: { poll: new_attributes, format: :json }
        poll.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the poll" do
        poll = Poll.create! valid_attributes
        patch poll_url(poll), params: { poll: new_attributes, format: :json }
        poll.reload
        expect(response).to redirect_to(poll_url(poll))
      end
    end

    context "with invalid parameters" do

      skip "renders a response with 422 status (i.e. to display the 'edit' template)" do
        poll = Poll.create! valid_attributes
        patch poll_url(poll), params: { poll: invalid_attributes, format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested poll" do
      poll = Poll.create! valid_attributes
      expect {
        delete poll_url(poll)
      }.to change(Poll, :count).by(-1)
    end
  end

  describe 'GET /results' do
    it 'gets the results of the  given poll' do
      poll = Poll.create!(valid_attributes)
      user =  User.create!(name: "The Employee1", email: 'employee1@oftheyear.com')
      candidate = Candidate.create!(name: 'Employee1', poll: poll)
      Vote.create!(candidate: candidate, user: user)
      Vote.create!(candidate: candidate, user: user)
      Candidate.create!(name: 'Employee2', poll: poll)

      poll_results = {
        'Employee1' => 2,
        'Employee2' => 0
      }
      get results_poll_path(poll)
      expect(response.status).to eq(200)
      response_json = JSON.parse(response.body)
      expect(response_json['data']).to eq(poll_results)
    end

    it 'renders a response with 404 if the poll cannot be found' do
      get results_poll_path('invalid')
      expect(response.status).to eq(404)
    end

    it 'renders a response with 500 if an unexpected error occurs' do
      poll = Poll.create! valid_attributes
      allow_any_instance_of(Poll).to receive(:results).and_raise('Error')
      get results_poll_path(poll)
      expect(response.status).to eq(500)
    end
  end
end
