class SVGA
  def initialize(args = {})
    args = { :href => '#' }.merge(args)
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
    @content = Array.new
  end
  
  attr_reader :content
  def << (element)
    @content << element
  end
  
  def to_xml(args = {})
    standalone = args[:standalone].nil? || args[:standalone].class == (TrueClass || FalseClass) ? true : args[:standalone]
    indent = args[:indent].nil? || args[:indent].class != Fixnum ? 0 : args[:indent]
    
    element = (standalone ? '' : @namespace + ':') + 'a'
    
    element << " xlink:href='#{@href}'"
    
    out = SVGHelper::wrap(element, indent)
    indent += 1
    
    @content.each do |element|
      out << element.to_xml(:standalone => standalone, :indent => indent)
    end
    
    indent -= 1
    out << SVGHelper::wrap('/' + (standalone ? '' : @namespace + ':') + 'a', indent)
  end
end