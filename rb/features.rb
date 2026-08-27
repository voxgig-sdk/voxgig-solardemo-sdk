# Solardemo SDK feature factory

require_relative 'feature/base_feature'
require_relative 'feature/test_feature'


module SolardemoFeatures
  def self.make_feature(name)
    case name
    when "base"
      SolardemoBaseFeature.new
    when "test"
      SolardemoTestFeature.new
    else
      SolardemoBaseFeature.new
    end
  end
end
