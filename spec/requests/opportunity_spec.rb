require "rails_helper"

RSpec.describe "/opportunities/:id", type: :request do
  describe "GET" do
    let(:params) { { carrier_id: } }
    let(:id) { [ 1, 2, 3 ].sample }

    context "Acme" do
      let(:carrier_id) { "1" }

      xit 'conforms to 200 schema' do
        expect(
          get("/opportunities/#{id}", params:)
        ).to conform_schema(200)
      end
    end

    context "Demo Carrier" do
      let(:carrier_id) { "2" }

      xit 'conforms to 200 schema' do
        expect(
          get("/opportunities/#{id}", params:)
        ).to conform_schema(200)
      end
    end
  end
end
