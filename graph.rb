class Graph

  attr_reader :vertices, :edges

  def self.random(v_count, min_degree, max_degree)
    if(max_degree < min_degree)
      puts "max degree ${max_degree} is less than min degree ${min_degree}"
      return false
    end
    if(min_degree > v_count - 1)
      puts "min_degree #{min_degree} too large"
      return false
    end
    if(max_degree > v_count - 1)
      puts "max_degree #{max_degree} too large"
    end
    res = Graph.new
    # add vertices one by one
    v_count.times do |n|
      next_vertex = ({ :x => (rand * 1280), :y => (rand * 720)})
      res.add(next_vertex)
    end
    
    res.each_v do |index_here, v_here|
      this_degree = ((rand * (max_degree - min_degree)) + min_degree).floor
      # find the closest points
      vid = -1
      
      closest_points = res.vertices.map do |v_there|
        vid += 1
        dx = (v_here[:x] - v_there[:x]).abs
        dy = (v_here[:y] - v_there[:y]).abs
        distance = Math.sqrt((dx ** 2) + (dy ** 2))
        close_point = [vid, distance]
      end
      closest_points.sort! { |a,b| a[1] <=> b[1] }
      to_connect = closest_points[1..this_degree]
      to_connect.each do |target|
        res.connect(index_here, target[0])
      end
    end
    return res
  end

  def initialize
    @vertices = []
    @edges = []
  end
  
  def serialize
    {
      :vertices => @vertices,
      :edges => @edges
    }
  end
  
  def inspect
    serialize.to_s
  end
  
  def to_s
    serialize.to_s
  end
  
  def each_v &block
    returnable = []
    @vertices.each_index do |i|
      returnable << yield(i,@vertices[i])
    end
    return returnable
  end
  
  def add pt
    @vertices << pt
  end

  def connect a, b
    if(@edges.include?([a,b]) or @edges.include?([b,a]))
      return false
    else
      @edges << [a, b]
    end
  end
  
  def cut i
    @edges.delete_at(i)
  end

  def disconnect a, b
    res = []
    @edges.each do |e|
      if((e == [a, b]) or (e == [b, a]))
      else
        res << e
      end
    end
    @edges = res
  end

  def remove pt_index
    @vertices.length.times do |n|
      disconnect pt_index, n
    end
    @vertices.delete_at(pt_index)
    @edges.each_index do |i|
      if(@edges[i][0] > pt_index)
        @edges[i][0] -= 1
      end
      
      if(@edges[i][1] > pt_index)
        @edges[i][1] -= 1
      end
    end
  end
  
  def order
    @vertices.length
  end
  
  def size
    @edges.length
  end
end