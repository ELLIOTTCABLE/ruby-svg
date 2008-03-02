# Created by elliottcable: elliottcable.name
# Licensed as Creative Commons BY-NC-SA 3.0 (creativecommons.org/licenses/by-nc-sa/3.0)
# -------------------------------------
# Some rake tasks to generate SVG tests
require 'lib/ruby-svg.rb'
require 'sass/engine'

desc 'Generate an example SVG file'
task :generate_test do
  sass = String.new
  sass <<"
svg
  rect#container, path.slice
    fill: none
    stroke: black
    stroke-width: 1
  path#slice_1
    fill: #FFFF00
  path#slice_2
    fill: #FF0000
  path#slice_3
    fill: #00FF00
  path#slice_4
    fill: #00FFFF
  path#slice_5
    fill: #0000FF
"
  style = Sass::Engine.new(sass, :style => :compact, :load_paths => ['.']).to_css
  s = SVG.new( :title => 'ruby-svg test',
    :desc => 'An SVG graphic to demonstrate some of the capabilities of the ruby-svg library.',
    :style => style )
    
  s << SVGRectangle.new(:id => 'container', :x => 1, :y => 1, :height => 498, :width => 498)
  
  # M200,200 L200,20 A180,180 0 0,1 377,231
  p = SVGPath.new(:class => 'slice', :id => 'slice_1')
  p << SVGPathMoveComponent.new(:x => 200, :y => 200)
  p << SVGPathLineComponent.new(:x => 200, :y => 20)
  p << SVGPathArcComponent.new(:rx => 180, :ry => 180, :x => 377, :y => 231, :direction => :american)
  a = SVGA.new(:href => 'http://google.com/')
  a << p
  s << a
  
  # M200,200 L377,231 A180,180 0 0,1 138,369
  p = SVGPath.new(:class => 'slice', :id => 'slice_2')
  p << SVGPathMoveComponent.new(:x => 200, :y => 200)
  p << SVGPathLineComponent.new(:x => 377, :y => 231)
  p << SVGPathArcComponent.new(:rx => 180, :ry => 180, :x => 138, :y => 369, :direction => :american)
  a = SVGA.new(:href => 'http://yahoo.com/')
  a << p
  s << a
  
  # M200,200 L138,369 A180,180 0 0,1 20,194
  p = SVGPath.new(:class => 'slice', :id => 'slice_3')
  p << SVGPathMoveComponent.new(:x => 200, :y => 200)
  p << SVGPathLineComponent.new(:x => 138, :y => 369)
  p << SVGPathArcComponent.new(:rx => 180, :ry => 180, :x => 20, :y => 194, :direction => :american)
  a = SVGA.new(:href => 'http://msn.com/')
  a << p
  s << a
  
  # M200,200 L20,194 A180,180 0 0,1 75,71
  p = SVGPath.new(:class => 'slice', :id => 'slice_4')
  p << SVGPathMoveComponent.new(:x => 200, :y => 200)
  p << SVGPathLineComponent.new(:x => 20, :y => 194)
  p << SVGPathArcComponent.new(:rx => 180, :ry => 180, :x => 75, :y => 71, :direction => :american)
  a = SVGA.new(:href => 'http://altavista.com/')
  a << p
  s << a
  
  # M200,200 L75,71 A180,180 0 0,1 200,20
  p = SVGPath.new(:class => 'slice', :id => 'slice_5')
  p << SVGPathMoveComponent.new(:x => 200, :y => 200)
  p << SVGPathLineComponent.new(:x => 74, :y => 71)
  p << SVGPathArcComponent.new(:rx => 180, :ry => 180, :x => 200, :y => 20, :direction => :american)
  a = SVGA.new(:href => 'http://digg.com/')
  a << p
  s << a
  
  
  f = File.open('example.svg','w')
  f << s.to_xml(:standalone => true)
  f.close
end