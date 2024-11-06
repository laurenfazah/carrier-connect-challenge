require "rails_helper"

RSpec.describe AcmeDataMapper do
  let(:our_data) do
    {
      id: "1",
      coverages: [
        {
          id: "700",
          product_type: "Vision",
          benefits: {
            commissions: "2%",
            frames: "$100 per year"
          }
        },
        {
          id: "701",
          product_type: "Dental",
          benefits: {
            commissions: "4%",
            x_ray_coinsurance: "20%"
          }
        }
      ]
    }
  end

  let(:expected) do
    {
      id: "1",
      coverages: [
        {
          id: "700",
          product_type: "Vision",
          benefits: {
            broker_commissions: "2",
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

  subject { described_class.new(our_data) }

  describe "#map" do
    it "maps the opportunity id" do
      expect(subject.map[:id]).to eq("1")
    end

    it "maps vision data correctly" do
      vision_coverage = subject.map[:coverages].find { |c| c[:product_type] == "Vision"
 }
      expect(vision_coverage[:id]).to eq("700")
      expect(vision_coverage[:broker_commissions]).to eq("2")
      expect(vision_coverage[:frame_benefit]).to eq("100")
    end

    it "maps dental data correctly" do
      dental_coverage = subject.map[:coverages].find { |c| c[:product_type] == "Dental"
 }
      expect(dental_coverage[:id]).to eq("701")
      expect(dental_coverage[:commissions]).to eq("0.04")
      expect(dental_coverage[:xray]).to eq("20%")
    end
  end
end
