class OpportunitiesController < ApplicationController
  def show
    render json: { opportunity_data:, carrier_name: }, status: :ok
  end

  private

  def opportunity_data
    data = StaticOpportunityData.find(params[:id])

    return AcmeDataMapper.new(data).map if carrier_id == "1"
    return data if carrier_id == "2"
  end

  def carrier_name
    {
      "1" => "Acme",
      "2" => "Demo Carrier"
    }[carrier_id]
  end

  def carrier_id
    params["carrier_id"]
  end
end
