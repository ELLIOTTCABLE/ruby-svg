class SVGRectangle
  def initialize(args = {})
    args = { :x => 0, :y => 0,
      :width => 500, :height => 500 }.merge(args)
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
    @content = Array.new
  end
  
  def to_xml(args = {})
    standalone = args[:standalone].nil? || args[:standalone].class == (TrueClass || FalseClass) ? true : args[:standalone]
    indent = args[:indent].nil? || args[:indent].class != Fixnum ? 0 : args[:indent]
    
    element = (standalone ? '' : @namespace + ':') + 'rect'
    [:x, :y, :width, :height, :id, :class, :style].each do |a|
      element << " #{a.to_s}='#{instance_variable_get('@' + a.to_s)}'" unless a.nil?
    end
    out = SVGHelper::wrap(element + "/", indent)
  end
end