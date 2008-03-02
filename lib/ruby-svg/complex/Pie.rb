class SVGPieChart
  
end

class SVGPieSlice
  # x, y, radius, percent, used
  def initialize(args = {})
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
    @angle = (2 * Math::PI) * (@percent / 100.0)
    @full = @percent + @used
  end
  
  def angle
    (2 * Math::PI) * (@percent -  / 100.0)
  end
  
  
end