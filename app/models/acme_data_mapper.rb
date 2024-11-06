class AcmeDataMapper
  attr_reader :opportunity_data

  def initialize(opportunity_data)
    @opportunity_data = opportunity_data
  end

  def map
    {
      id: opportunity_data[:id],
      coverages: map_coverages
    }
  end

  private

  def map_coverages
    opportunity_data[:coverages].map do |coverage|
      if coverage[:product_type].downcase == "vision"
        {
          id: coverage[:id],
          product_type: "Vision",
          benefits: {
            broker_commissions: map_commissions(
              coverage[:benefits][:commissions]
            ),
            frame_benefit: map_frames(
              coverage[:benefits][:frames]
            )
          }
        }
      elsif coverage[:product_type].downcase == "dental"
        {
          id: coverage[:id],
          product_type: "Dental",
          benefits: {
            commissions: map_commissions(
              coverage[:benefits][:commissions]
            ),
            xray: map_x_ray_coinsurance(
              coverage[:benefits][:x_ray_coinsurance]
            )
          }
        }
      end
    end
  end

  def map_commissions(detail)
    number = detail.gsub!("%", "")
    (number.to_f / 100).to_s
  end

  def map_frames(detail)
    number = detail.scan(/\$\d+/).join('')

    return if number.empty?

    number.gsub("$", "")
  end

  def map_x_ray_coinsurance(detail)
    number = detail.gsub!("%", "")
    "#{number.to_f.ceil}%"
  end

  def is_percentage?(detail)
    return unless detail.is_a? String

    !!(detail =~ /^\d+(\.\d+)?%$/)
  end
end
