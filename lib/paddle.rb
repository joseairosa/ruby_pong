class Paddle
  WIDTH = 16
  HEIGHT = 96
  SPEED = 10

  attr_reader :side, :y

  def initialize(side)
    @side = side
    @y = Game::HEIGHT/2
  end

  def up!
    @y -= SPEED if y1 > 0
  end

  def down!
    @y += SPEED if y4 < Game::HEIGHT
  end

  def x1
    case side
      when :left
        0
      when :right
        Game::WIDTH - WIDTH
      else
        # do nothing
    end
  end
  alias_method :x4, :x1  

  def x2
    x1 + WIDTH
  end
  alias_method :x3, :x2

  def y1
    y - HEIGHT/2
  end
  alias_method :y2, :y1

  def y4
    y1 + HEIGHT
  end
  alias_method :y3, :y4

  # (x1, y1) (x2, y2)
  #     +-------+
  #     |       |
  #     |       |
  #     |(x, y) |
  #     |   .   |
  #     |       |
  #     |       |
  #     |       |
  #     +-------+
  # (x4, y4) (x3, y3)

  def draw(window)
    color = Gosu::Color::WHITE
    window.draw_quad(
        x1, y1, color,
        x2, y2, color,
        x3, y3, color,
        x4, y4, color
    )
  end
end
