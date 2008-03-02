require 'ruby-svg/primatives/path'
require 'ruby-svg/primatives/rectangle'
require 'ruby-svg/primatives/a'
require 'ruby-svg/complex/pie'

class SVG
  def initialize(args = {})
    args = { :encoding => 'UTF-8',
      :doctype => 'svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"',
      :namespace => 'svg',
      :width => 500,
      :height => 500 }.merge(args)
    args.each do |k,v|
      self.instance_variable_set(('@' + k.to_s).to_sym, v)
    end
    @content = Array.new
  end
  
  attr_accessor :style
  attr_accessor :title
  attr_accessor :desc
  
  attr_reader :content
  def << (element)
    @content << element
  end
  
  def to_xml(args = {})
    standalone = args[:standalone].nil? || args[:standalone].class == (TrueClass || FalseClass) ? true : args[:standalone]
    indent = args[:indent].nil? || args[:indent].class != Fixnum ? 0 : args[:indent]
    indent = 0 if standalone
    
    out = Array.new
    if standalone
      out << SVGHelper::wrap("?xml version='1.0' encoding='#{@encoding}' standalone='no'?", indent)
      out << SVGHelper::wrap("!DOCTYPE #{@doctype}", indent)
    end
    
    # Header
    header = String.new
    header << (standalone ? '' : @namespace + ':') + 'svg'
    [:width, :height].each do |a|
      header << " #{a.to_s}='#{instance_variable_get('@' + a.to_s)}'"
    end
    header << " version='1.1' xmlns='http://www.w3.org/2000/svg'" if standalone
    header << " xmlns:xlink='http://www.w3.org/1999/xlink'"
    out << SVGHelper::wrap(header, indent)
      indent += 1
      
      {:title => {}, :style => {:type => 'text/css'}, :desc => {}}.each do |tag,attribs|
        it = instance_variable_get('@' + tag.to_s)
        unless it.nil?
          header = (standalone ? '' : @namespace + ':') + tag.to_s
          attribs.each do |k,v|
            header << " #{k}='#{v}'"
          end
          out << SVGHelper::wrap(header, indent)
            indent += 1
            lines = ''
            it.each do |line|
              lines << SVGHelper::indent(line, indent)
            end
            out << lines.sub(/([^\n])\z/, "\\1\n")
            indent -= 1
          out << SVGHelper::wrap('/' + tag.to_s, indent)
        end
      end
      
      @content.each do |element|
        out << element.to_xml(:standalone => standalone, :indent => indent)
      end
    
      indent -= 1
    out << SVGHelper::wrap('/' + (standalone ? '' : @namespace + ':') + 'svg', indent).chomp
  end
end

class SVGHelper
  def self.wrap(c, indent = 0)
    SVGHelper::indent("<#{c}>", indent) + "\n"
  end
  
  def self.indent(c, level)
    ('  ' * level) + c
  end
end