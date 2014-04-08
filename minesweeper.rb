require 'debugger'

class Minesweeper
  attr_accessor :board
  def initialize
    @board = Board.new
    #display
  end

  def start
    #puts "how many bombs do you want"
    #bombs = gets.chomp
    run
  end

  def run
    #until self.board.over?
    stop = false
    until stop
      play_turn
    end
  end

  def play_turn
    self.display
    puts "Select your position"
    position = gets.chomp.split(' ').map {|x| x.to_i}
    #debugger

    play_tile(position)

  end
  
  #takes an array [x, y]
  def play_tile(pos)
    reveal_tiles(pos)
    #reveal returns if position has bomb or not.
  end

  def reveal_tiles(pos)
    #debugger
    if @board.get_tile(pos).bomb?
      game_over
    else
      @board.get_tile(pos).reveal
      # self.display
    end
  end

  def game_over

  end

  def display
    (0..8).each do |el1|
      (0..8).each do |el2|
        if @board.get_tile([el1, el2]).revealed
          if @board.get_tile([el1, el2]).bomb?
            print "B  "
          else
            print "#{@board.get_tile([el1, el2]).neighbor_bomb_count}  "
          end
        else
          print "U  "
        end
      end
      print "\n"
    end

  end

end
#-----------------------------------------
class Tile
  attr_accessor :pos, :board, :bomb, :revealed, :mark

  def initialize(pos, board)
    self.bomb = false
    self.bomb = true if rand(10) == 1
    self.revealed = false
    self.pos = pos
    self.mark = "U"
    self.board = board
  end

  def show_tile
    if !self.revealed
      "U"
    elsif !self.bomb?
      self.count.to_s
    else

    end

  end


  def revealed?
    self.revealed
  end

  def bomb?
    self.bomb
  end

  def reveal
    self.revealed = true
    self.mark = self.neighbor_bomb_count
    self.neighbors.each do |neighbor|
      if !@board.get_tile(neighbor).revealed?
        if @board.get_tile(neighbor).neighbor_bomb_count == 0
          @board.get_tile(neighbor).reveal
        elsif @board.get_tile(neighbor).neighbor_bomb_count > 1
          #debugger
          @board.get_tile(neighbor).reveal
        end
      end
    end
  end

  def neighbors
    #returns [[0,1], [1, 0]...]
    #relative_neighbor_coordinates
    neighbors = [ [-1, -1], [0, -1], [1, -1], [-1, 0],
                       [1, 0], [-1, 1], [0, 1], [1, 1] ]

    neighbors.map! { |rnc_pos|
                [ rnc_pos[0] + self.pos[0],
                  rnc_pos[1] + self.pos[1] ] }

    neighbors.select! { |rnc_pos|
                rnc_pos[0] >= 0 && rnc_pos[0] < 9 &&
                rnc_pos[1] >= 0 && rnc_pos[1] < 9 } #&&
                #!(self.bomb?)

    #returns an array containing neighbor coordinates as a [x, y]
    neighbors
  end

  def neighbor_bomb_count
    bombs = 0
    self.neighbors.each do |neighbor|
      #p neighbor
      if self.board.get_tile(neighbor).bomb?
        bombs += 1
      end
    end
    bombs
  end
end

#-----------------------------------------
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    self.set_board


    (0..8).each do |row|
      (0..8).each do |tile|
        a_tile = @grid[row][tile]

        if a_tile.bomb?
          #debugger
          a_tile.bomb = true
          # neighbors = a_tile.neighbors
          # neighbors.each do |neighbor|
          #   @grid[neighbor[0]][neighbor[1]].neighbor_bomb_count += 1
          # end
          #tile.neighbor_bomb_count(board)
        end
      end
    end

  end

  def set_board
    (0..8).each do |row|
      (0..8).each do |col|
        @grid[row][col] = Tile.new([row, col], self)
      end
    end
  end

  def get_tile(pos)
    @grid[pos.first][pos.last]
  end
end

m = Minesweeper.new
m.start