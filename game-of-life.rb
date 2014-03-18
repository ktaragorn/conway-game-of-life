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

  def live_char
    "o"
    # rand(255).chr
  end

  def to_s
    @alive ? "#{live_char} " : "  "
  end
end

class Grid
  X = 30
  Y = 30
  def initialize(live_array)
    @grid = [[]] 

    X.times do |x|
      Y.times do |y|
        @grid[x] << Cell.new(Array(live_array[x])[y] && live_array[x][y].downcase == "x")
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
    puts @grid.map{|arr| arr.join}.join "\n"
  end
end

#initialize

g = Grid.new([
  [],[],[],[],
  %w(. . . X X X . X),
  %w(. . . X . . . .),
  %w(. . . . . . X X),
  %w(. . . . x x . x),
  %w(. . . x . X . x),
  %w(. . . . . . . .),
  ])
tick_count= 0
loop do 
  g.tick
  system "clear"
  g.print
  puts tick_count
  tick_count += 1
  #sleep 0.01
end