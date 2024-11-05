class OpportunitiesController < ApplicationController
  def show
    render json: { opportunity_data:, carrier_name: }, status: :ok
  end

  private

  def opportunity_data
    StaticOpportunityData.find(params[:id])
  end

  def carrier_name
    {
      "1" => "Acme",
      "2" => "Demo Carrier"
    }[params["carrier_id"]]
  end
end
