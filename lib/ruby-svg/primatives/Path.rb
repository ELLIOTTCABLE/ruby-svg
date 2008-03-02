class SVGPath
  def initialize(args = {})
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
    @descriptors = Array.new
  end
  
  attr_reader :descriptors
  
  def <<(descriptor)
    @descriptors << descriptor
  end
  
  def to_xml(args = {})
    standalone = args[:standalone].nil? || args[:standalone].class == (TrueClass || FalseClass) ? true : args[:standalone]
    indent = args[:indent].nil? || args[:indent].class != Fixnum ? 0 : args[:indent]
    
    element = (standalone ? '' : @namespace + ':') + 'path'
    
    descriptors = String.new
    @descriptors.each do |descriptor|
      descriptors << descriptor.to_s + " "
    end
    descriptors << "Z"
    
    element << " d='#{descriptors}'"
    
    [:id, :class, :style].each do |a|
      element << " #{a.to_s}='#{instance_variable_get('@' + a.to_s)}'" unless a.nil?
    end
    out = SVGHelper::wrap(element + "/", indent)
  end
end

class SVGPathMoveComponent
  def initialize(args = {})
    args = { :x => 0, :y => 0 }.merge(args)
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
  end
  
  def to_s
    "M#{@x},#{@y}"
  end
end
class SVGPathLineComponent
  def initialize(args = {})
    args = { :x => 0, :y => 0 }.merge(args)
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
  end
  
  def to_s
    "L#{@x},#{@y}"
  end
end
class SVGPathArcComponent
  # :direction => :american
  def initialize(args = {})
    args = { :rx => 100, :ry => 100, :slant => 0, :long => false, :direction => :cartesian, :x => 100, :y => 100 }.merge(args)
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
  end
  
  def to_s
    long = @long ? 1 : 0
    direction = case @direction
    when :cartesian
      0
    when :american
      1
    end
    
    "A#{@rx},#{@ry} #{@slant} #{long},#{direction} #{@x},#{@y}"
  end
end