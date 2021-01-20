# Graph Kayles
=begin
This is a generalization of Kayles
to be used for strategic calculation in Warbride.

A Kayles position can be seen as a graph where every vertex
is of degree not more than 2. A move is removing one node
from anywhere, or two connected nodes.

Graph Kayles generalizes this to nodes of arbitrary degree.
=end

$gtk.reset seed: Time.new.to_i

class Object
  def log *args
    #do nothing
  end
end

require "app/point.rb"
require "app/graph.rb"
require "app/kayles.rb"

def put_once flag, str
  if(!$checkpoints[flag])
    puts str
    $checkpoints[flag] = true
  end
end

def put_every frames, str
  if($args.state.tick_count % frames == 0)
    puts str
  end
end

$checkpoints = []

def swap_players
  if($args.state.player == "Left")
    $args.state.player = "Right"
  else
    $args.state.player = "Left"
  end
end

def tick args
  args.gtk.log_level = :off
  if(args.state.tick_count == 0)
    args.state.kayles = Kayles.new(12,2,2)
    args.state.begun = true
    args.state.player = "Left"
    args.state.annotations = []
  end
  args.outputs.labels << [ 10, 710, "#{args.state.player} to move" ]
  mouse = args.inputs.mouse
  args.state.kayles.activate(mouse.x,mouse.y)
  args.state.kayles.draw args.outputs
  graph = args.state.kayles.graph
  edge = args.state.kayles.active_edge
  vertex = args.state.kayles.active_vertex
  if(edge)
    args.outputs.labels << [mouse.x + 20, mouse.y, graph.edges[edge].to_s]
  else
    args.outputs.labels << [mouse.x + 20, mouse.y, vertex.to_s]
  end
  
  if(mouse.button_left)
    if(args.state.kayles.active_vertex)
      args.state.kayles.remove
      swap_players
    elsif(args.state.kayles.active_edge)
      args.state.kayles.cut
      swap_players
    end
  elsif(mouse.button_right)
    # if no vertex is selected or highlighted,
    # put a new vertex here.
    # if no vertex is selected but one is highlighted,
    # select that vertex
    # if a vertex is selected but none highlighted
    # create a vertex and connect to selected, then deselect
    # if a vertex is selected and another is highlighted
    # connect them
    # if the same vertex is highlighted and selected
    # deselect it.
  end
  args.state.annotations.each do |a|
    args.outputs.labels << [ a[:x], a[:y], a[:s] ]
  end
end