class Ball
  SIZE = 16
  attr_reader :x, :y, :angle, :speed

  def initialize
    @x = Game::WIDTH/2
    @y = Game::HEIGHT/2

    @angle = rand(120) + 30
    @angle *= -1 if rand > 0.5
    @speed = 8
  end

  def dx; Gosu::offset_x(angle, speed) end
  def dy; Gosu::offset_y(angle, speed) end

  # (x1, y1)     (x2, y2)
  #     +-----------+
  #     |   (x, y)  |
  #     |     .     |
  #     |           |
  #     |           |
  #     +-----------+
  # (x4, y4)     (x3, y3)

  def x1; @x - SIZE/2 end
  alias_method :x4, :x1  
  def x2; @x + SIZE/2 end
  alias_method :x3, :x2
  def y1; @y - SIZE/2 end
  alias_method :y2, :y1
  def y4; @y + SIZE/2 end
  alias_method :y3, :y4

  def bounce_off_edge!
    if @y <= 0
      @y = 0
      @angle = Gosu.angle(0, 0, dx, -dy)
    end

    if @y >= Game::HEIGHT
      @y = Game::HEIGHT
      @angle = Gosu.angle(0, 0, dx, -dy)
    end
  end

  def intersects?(paddle)
    x1 < paddle.x2 &&
        x2 > paddle.x1 &&
        y1 < paddle.y4 &&
        y4 > paddle.y1
  end

  def bounce_off_paddle!(paddle)
    case paddle.side
      when :left
        @x = paddle.x2 + SIZE/2
      when :right
        @x = paddle.x1 - SIZE/2
      else
        # do nothing
    end

    @angle = Gosu.angle(0, 0, -dx, dy)

  #  -0.5 +-------+
  #       |       |
  #       |       |
  #       |       |
  #     0 |       | ratio
  #       |       |
  #       |       |
  #       |       |
  #   0.5 +-------+

    ratio = (y - paddle.y) / Paddle::HEIGHT
    @angle = ratio * 120 + 90
    @angle *= -1 if paddle.side == :right

    @speed *= 1.1
  end

  def off_left?
    x1 < 0
  end

  def off_right?
    x2 > Game::WIDTH
  end

  def move!
    @x += dx
    @y += dy

    bounce_off_edge!
  end

  def draw(window)
    color = Gosu::Color::RED
    window.draw_quad(
        x1, y1, color,
        x2, y2, color,
        x3, y3, color,
        x4, y4, color
    )
  end
end
