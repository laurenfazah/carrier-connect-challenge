require 'rails_helper'

RSpec.describe OpportunitiesController do
  describe "#show" do
    let(:carrier_id) { "1" }
    let(:opportunity_id) { "1" }

    let(:params) do
      { id: opportunity_id, carrier_id: carrier_id }
    end

    context "when carrier is Acme" do
      let(:expected) do
        {
          id: "1",
          coverages: [
            {
              id: "700",
              product_type: "Vision",
              benefits: {
                broker_commissions: "0.02",
                frame_benefit: "100"
              }
            },
            {
              id: "701",
              product_type: "Dental",
              benefits: {
                commissions: "0.04",
                xray: "20%"
              }
            }
          ]
        }
      end

      before do
        get :show, params: params
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end

      it "includes opportunity data in the response" do
        parsed_response = JSON.parse(
          response.body,
          symbolize_names: true
        )

        expect(parsed_response[:opportunity_data])
          .to eq expected
      end
    end
  end
end