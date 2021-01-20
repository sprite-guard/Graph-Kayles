class Kayles

  @@active_color = [255, 128, 40]
  @@inactive_color = [0,0,0]
  
  @@vertex_width = 10
  @@vertex_height = 10
  
  attr_reader :active_vertex, :active_edge, :graph

  def initialize v, cmin, cmax
    if(v > 0)
      @graph = Graph.random(v, cmin, cmax)
    else
      @graph = Graph.new
    end
    @active_vertex = false
    @active_edge = false
    @warm_edges = []
  end
  
  def cut
    if(@active_edge)
      @graph.cut(active_edge)
      @active_edge = false
    else
      return false
    end
  end
  
  def remove
    if(@active_vertex)
      @graph.remove(@active_vertex)
      @active_vertex = false
    else
      return false
    end
  end
  
  def activate px, py
    # if we're inside of a vertex bounding box,
    # activate that one.
    @graph.vertices.each_with_index do |v,id|
      w = @@vertex_width
      h = @@vertex_height
      x = v[:x] - (w/2)
      y = v[:y] - (h/2)
      if [px,py].inside_rect? [x, y, w, h]
        @active_vertex = id
        @active_edge = false
        return
      else
        @active_vertex = false
      end
    end
    
    # if we're not in a vertex box,
    # find the closest edge
    best_distance = 20
    best_edge = false
    @graph.edges.each.with_index do |current_edge,edge_index|
      a = @graph.vertices[current_edge[0]]
      b = @graph.vertices[current_edge[1]]
      distance = Point.distance_to_segment({x: px, y: py}, a, b)
      if(distance < best_distance)
        best_distance = distance
        best_edge = edge_index
      end
    end
    @active_edge = best_edge
  end
  
  def draw surface
    @graph.vertices.each_with_index do |vertex,id|
      #draw every vertex
      w = @@vertex_width
      h = @@vertex_height
      x = vertex[:x] - (w/2)
      y = vertex[:y] - (h/2)
      
      color = @@inactive_color
      if @active_vertex == id
        color = @@active_color
      end
      surface.solids << [x, y, w, h, color]
    end
    
    @graph.edges.each_with_index do |edge,id|
      #draw every edge
      va = @graph.vertices[edge[0]]
      vb = @graph.vertices[edge[1]]
      x = [va[:x], vb[:x]]
      y = [va[:y], vb[:y]]
      
      color = @@inactive_color
      if @active_edge == id
        color = @@active_color
      end
      surface.lines << [x[0], y[0], x[1], y[1], color]
    end
  end
  
  def serialize
    {
      :graph => @graph,
      :active_vertex => @active_vertex,
      :active_edge => @active_edge,
      :warm_edges => @warm_edges
    }
  end
  
  def inspect
    serialize.to_s
  end
  
  def to_s
    serialize.to_s
  end
end