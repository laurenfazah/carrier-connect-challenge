class OpportunitiesController < ApplicationController
  def show
    render json: { opportunity_data:, carrier_name: }, status: :ok
  end

  private

  def opportunity_data
    data = StaticOpportunityData.find(params[:id])

    return acme_data(data) if carrier_id == "1"
    return demo_carrier_data(data) if carrier_id == "2"
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

  def acme_data(data)
    AcmeDataMapper.new(data).map
  end

  def demo_carrier_data(data)
    DemoCarrierDataMapper.new(data).map
  end
end
