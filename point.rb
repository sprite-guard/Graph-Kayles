module Point

  def Point.distance_to_line test_point, endpoint_a, endpoint_b
    baseline_dx = (endpoint_a[:x] - endpoint_b[:x])
    baseline_dy = (endpoint_a[:y] - endpoint_b[:y])
    point_dx = (endpoint_a[:x] - test_point[:x])
    point_dy = (endpoint_a[:y] - test_point[:y])
    
    baseline_length = Math.sqrt(baseline_dx**2 + baseline_dy**2)
    triangle = (
      (baseline_dx * point_dy) - (point_dx * baseline_dy)
    ).abs
    
    return (triangle / baseline_length).abs
  end
  
  def Point.distance a, b
    dx = Math.abs(a[:x] - b[:x])
    dy = Math.abs(a[:y] - b[:y])
    return Math.sqrt(dx**2 + dy**2)
  end
  
  def Point.closest_on_line p, a, b
    a_to_p = {
      :x => p[:x] - a[:x],
      :y => p[:y] - a[:y]
    }
    a_to_b = {
      :x => b[:x] - a[:x],
      :y => b[:y] - a[:y]
    }
    a_to_b_squared = a_to_b[:x]**2 + a_to_b[:y]**2
    dot_product = a_to_p[:x]*a_to_b[:x] + a_to_p[:y]*a_to_b[:y]
    offset = dot_product / a_to_b_squared
    return {
      :x => a[:x] + (a_to_b[:x]*offset),
      :y => a[:y] + (a_to_b[:y]*offset)
    }
  end
  
  def Point.distance_to_segment test_point, endpoint_a, endpoint_b
    left = [endpoint_a[:x], endpoint_b[:x]].min
    right = [endpoint_a[:x], endpoint_b[:x]].max
    top = [endpoint_a[:y], endpoint_b[:y]].max
    bottom = [endpoint_a[:y], endpoint_b[:y]].min
    
    closest_point = Point.closest_on_line test_point, endpoint_a, endpoint_b
    
    if(
      (closest_point[:x] < left) ||
      (closest_point[:x] > right) ||
      (closest_point[:y] < bottom) ||
      (closest_point[:y] > top)
    )
      return false
    else
      return Point.distance_to_line test_point, endpoint_a, endpoint_b
    end
  end
end