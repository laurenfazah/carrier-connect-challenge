require "rails_helper"

RSpec.describe AcmeDataMapper do
  let(:x_ray_coinsurance) { "20%" }
  let(:dental_commissions) { "4%" }
  let(:vision_commissions) { "2%" }
  let(:frames) { "$100 per year" }

  let(:our_data) do
    {
      id: "1",
      coverages: [
        {
          id: "700",
          product_type: "Vision",
          benefits: {
            commissions: vision_commissions,
            frames: frames
          }
        },
        {
          id: "701",
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

  subject { described_class.new(our_data) }

  describe "#map" do
    it "maps the opportunity data" do
      expect(subject.map).to eq expected
    end

    it "maps the opportunity id" do
      expect(subject.map[:id]).to eq("1")
    end

    it "maps vision data correctly" do
      vision_coverage = subject.map[:coverages].find { |c| c[:product_type] == "Vision"
 }
      expect(vision_coverage[:id]).to eq("700")
      expect(vision_coverage[:benefits][:broker_commissions]).to eq("0.02")
      expect(vision_coverage[:benefits][:frame_benefit]).to eq("100")
    end

    it "maps dental data correctly" do
      dental_coverage = subject.map[:coverages].find { |c| c[:product_type] == "Dental"
 }
      expect(dental_coverage[:id]).to eq("701")
      expect(dental_coverage[:benefits][:commissions]).to eq("0.04")
      expect(dental_coverage[:benefits][:xray]).to eq("20%")
    end
  end

   context "vision edge cases" do
     let(:vision_coverage) do
       subject.map[:coverages].find { |c| c[:product_type] == "Vision" }
     end

     describe "vision commissions is PEPM" do
       let (:vision_commissions) { "PEPM" }

       it "returns PerEmployee" do
         expect(vision_coverage[:benefits][:broker_commissions]).to eq("PerEmployee")
       end
     end

     describe "vision commissions is 'Per Employee'" do
       let (:vision_commissions) { "Per Employee" }

       it "returns PerEmployee" do
         expect(vision_coverage[:benefits][:broker_commissions]).to eq("PerEmployee")
       end
     end

     describe "vision commissions is 'Per Employee Per Month' (case insensitive)" do
       let (:vision_commissions) { "Per Employee Per Month" }

       it "returns PerEmployee" do
         expect(vision_coverage[:benefits][:broker_commissions]).to eq("PerEmployee")
       end
     end

     describe "PEPM is case insensitive" do
       let (:vision_commissions) { "PER EMPLOYEE PER MONTH" }

       it "returns PerEmployee" do
         expect(vision_coverage[:benefits][:broker_commissions]).to eq("PerEmployee")
       end
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

     describe "frames have multiple numbers in string" do
       let(:frames) { "$100 every 2nd year" }

       it "only extracts the dollar amount" do
         expect(vision_coverage[:benefits][:frame_benefit]).to eq("100")
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
         expect(dental_coverage[:benefits][:xray]).to eq("21%")
       end
     end

     describe "x_ray_coinsurance not percentage" do
       let(:x_ray_coinsurance) { "foo" }

       it "returns nil" do
         expect(dental_coverage[:benefits][:xray]).to be_nil
       end
     end

     describe "commissions not percentage" do
       let(:dental_commissions) { "foo" }

       it "returns nil" do
         expect(dental_coverage[:benefits][:commissions]).to be_nil
       end
     end
   end
end
