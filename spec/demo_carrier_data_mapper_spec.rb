require "rails_helper"

RSpec.describe DemoCarrierDataMapper do
  let(:x_ray_coinsurance) { "30%" }
  let(:dental_commissions) { "Flat $1000" }
  let(:vision_commissions) { "$1 PEPM" }
  let(:frames) { "Not Included" }

  let(:our_data) do
    {
      id: "2",
      coverages: [
        {
          id: "702",
          product_type: "Vision",
          benefits: {
            commissions: vision_commissions,
            frames: frames
          }
        },
        {
          id: "703",
          product_type: "Dental",
          benefits: {
            commissions: dental_commissions,
            x_ray_coinsurance: x_ray_coinsurance
          }
        }
      ]
    }
  end

  let(:expected) do
    {
      id: "2",
      coverages: [
        {
          id: "702",
          product_type: "Vision",
          benefits: {
            broker_commissions: nil,
            frame_benefit: nil
          }
        },
        {
          id: "703",
          product_type: "Dental",
          benefits: {
            commissions: {
              commissions_pct: nil,
              commissions_structure: "Flat"
            },
            x_ray_coinsurance: "30"
          }
        }
      ]
    }
  end

  subject { described_class.new(our_data) }

  describe "#map" do
    it "maps the opportunity data" do
      expect(subject.map).to eq expected
    end

    it "maps the opportunity id" do
      expect(subject.map[:id]).to eq("2")
    end

    it "maps vision data correctly" do
      vision_coverage = subject.map[:coverages].find { |c| c[:product_type] == "Vision"
 }
      expect(vision_coverage[:id]).to eq("702")
      expect(vision_coverage[:benefits][:broker_commissions]).to be_nil
      expect(vision_coverage[:benefits][:frame_benefit]).to be_nil
    end

    it "maps dental data correctly" do
      dental_coverage = subject.map[:coverages].find { |c| c[:product_type] == "Dental"
 }
      expect(dental_coverage[:id]).to eq("703")
      expect(dental_coverage[:benefits][:commissions][:commissions_pct]).to be_nil
      expect(dental_coverage[:benefits][:commissions][:commissions_structure]).to eq "Flat"
      expect(dental_coverage[:benefits][:x_ray_coinsurance]).to eq("30")
    end
  end

  context "vision edge cases" do
    let(:vision_coverage) do
      subject.map[:coverages].find { |c| c[:product_type] == "Vision" }
    end

    describe "vision commissions is not percentage or per employee" do
      let (:vision_commissions) { "foo" }

      it "returns nil" do
        expect(vision_coverage[:benefits][:broker_commissions]).to be_nil
      end
    end

    describe "frames not dollar amount" do
      let(:frames) { "foo" }

      it "returns nil" do
        expect(vision_coverage[:benefits][:frame_benefit]).to be_nil
      end
    end
  end

  context "dental edge cases" do
    let(:dental_coverage) do
      subject.map[:coverages].find { |c| c[:product_type] == "Dental" }
    end

    describe "x_ray_coinsurance not whole number" do
      let(:x_ray_coinsurance) { "20.5%" }

      it "rounds up to nearest whole number percentage" do
        expect(dental_coverage[:benefits][:x_ray_coinsurance]).to eq("21")
      end
    end

    describe "x_ray_coinsurance not percentage" do
      let(:x_ray_coinsurance) { "foo" }

      it "returns nil" do
        expect(dental_coverage[:benefits][:x_ray_coinsurance]).to be_nil
      end
    end

    describe "commissions is percentage" do
      let(:dental_commissions) { "20%" }

      it "returns the percentage details" do
        expect(dental_coverage[:benefits][:commissions][:commissions_pct]).to eq "20"
        expect(dental_coverage[:benefits][:commissions][:commissions_structure]).to eq "Percent"
      end
    end
  end
end
