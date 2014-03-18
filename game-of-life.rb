# encoding: utf-8
class Cell
  attr_accessor :live_neighbours

  def initialize(alive = true)
    @alive = alive
  end

  def alive?
    @alive
  end

  def update_status
    if alive?
      if live_neighbours < 2
        @alive = false
      elsif live_neighbours > 3
        @alive = false
      end
    else
      if live_neighbours == 3
        @alive = true
      end
    end
  end

  def to_s
    @alive ? (rand*255).to_i.chr+" " : "  "
  end
end

class Grid
  X = 30
  Y = 30
  def initialize(live_array)
    @grid = [[]] 

    X.times do |x|
      Y.times do |y|
        @grid[x] << Cell.new(Array(live_array[x])[y] == "x")
      end
      @grid<<[]
    end   
  end

  def tick

    each do |x,y|
      @grid[x][y].live_neighbours = neighbour_indices(x,y).inject(0){|alive,(x,y)| alive + (@grid[x][y].alive? ? 1: 0)}
    end

    each {|x,y| @grid[x][y].update_status}
  end

  def neighbour_indices x,y
    (-1..1).map do |x_diff|
      (-1..1).map do |y_diff|
        next if x_diff == 0 && y_diff == 0
        nextx = (x+x_diff) % X
        nexty = (y+y_diff) % Y
        [nextx,nexty]
      end.compact
    end.flatten 1
  end

  def each 
    return unless block_given?

    X.times do |x|
      Y.times do |y|
        yield(x,y)
      end
    end   
  end

  def print
    @grid.each do |array|
      puts array.join
    end
  end
end

#initialize

g = Grid.new([
  [],[],
  %w(o o o o o x),
  %w(o o o x o x),
  %w(o o o o x x),
  %w(o o o o x x),
  %w(o o o x o x),
  %w(o o o o o x),
  ])
tick_count= 0
loop do 
  system "clear"
  g.tick
  g.print
  puts tick_count
  tick_count += 1
  sleep 0.1
end