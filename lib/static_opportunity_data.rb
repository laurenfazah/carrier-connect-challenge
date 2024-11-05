module StaticOpportunityData
  def self.find(opportunity_id)
    data[opportunity_id]
  end

  def self.data
    {
      "1" => {
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
      },
      "2" => {
        id: "2",
        coverages: [
          {
            id: "702",
            product_type: "Vision",
            benefits: {
              commissions: "$1 PEPM",
              frames: "Not Included"
            }
          },
          {
            id: "703",
            product_type: "Dental",
            benefits: {
              commissions: "Flat $1000",
              x_ray_coinsurance: "30%"
            }
          }
        ]
      },
      "3" => {
        id: "3",
        coverages: [
          {
            id: "704",
            product_type: "Vision",
            benefits: {
              commissions: "1.5%",
              frames: "$125"
            }
          },
          {
            id: "705",
            product_type: "Dental",
            benefits: {
              commissions: "2.5%",
              x_ray_coinsurance: "25 percent"
            }
          }
        ]
      }
    }
  end
end
