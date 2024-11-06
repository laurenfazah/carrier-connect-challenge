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
        mapped_vision_coverage(coverage)
      elsif coverage[:product_type].downcase == "dental"
        mapped_dental_coverage(coverage)
      end
    end
  end

  def mapped_vision_coverage(coverage)
    {
      id: coverage[:id],
      product_type: "Vision",
      benefits: {
        broker_commissions: map_vision_commissions(
          coverage[:benefits][:commissions]
        ),
        frame_benefit: map_frames(
          coverage[:benefits][:frames]
        )
      }
    }
  end

  def mapped_dental_coverage(coverage)
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

  def map_commissions(detail)
    number = detail.gsub!("%", "")

    return unless number

    (number.to_f / 100).to_s
  end

  def map_vision_commissions(detail)
    return unless detail.is_a? String

    detail = detail.downcase
    pe_strings = ["pepm", "per employee", "per employee per month"]

    return "PerEmployee" if pe_strings.include?(detail)

    map_commissions(detail)
  end

  def map_frames(detail)
    number = detail.scan(/\$\d+/).join('')

    return if number.empty?

    number.gsub("$", "")
  end

  def map_x_ray_coinsurance(detail)
    number = detail.gsub!("%", "")

    return unless number

    "#{number.to_f.ceil}%"
  end

  def is_percentage?(detail)
    return unless detail.is_a? String

    !!(detail =~ /^\d+(\.\d+)?%$/)
  end
end
