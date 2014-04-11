require 'bundler/setup'
require 'hasu'

Hasu.load 'lib/ball.rb'
Hasu.load 'lib/paddle.rb'

class Game < Hasu::Window
  WIDTH = 1024
  HEIGHT = 768

  def initialize
    super(WIDTH, HEIGHT, false)
  end

  def reset
    @background_image = Gosu::Image.new(self, 'assets/codebits.png', true)

    @ball = Ball.new
    
    @left_paddle = Paddle.new(:left)
    @right_paddle = Paddle.new(:right)

    @left_score = 0
    @right_score = 0

    @font = Gosu::Font.new(self, 'Verdana', 30)
  end

  def update
    @ball.move!

    if button_down?(Gosu::KbW)
      @left_paddle.up!
    end

    if button_down?(Gosu::KbS)
      @left_paddle.down!
    end

    if button_down?(Gosu::KbUp)
      @right_paddle.up!
    end

    if button_down?(Gosu::KbDown)
      @right_paddle.down!
    end

    if @ball.intersects?(@left_paddle)
      @ball.bounce_off_paddle!(@left_paddle)
    end

    if @ball.intersects?(@right_paddle)
      @ball.bounce_off_paddle!(@right_paddle)
    end

    if @ball.off_left?
      @right_score += 1
      @ball = Ball.new
    end

    if @ball.off_right?
      @left_score += 1
      @ball = Ball.new
    end
  end

  def draw
    @background_image.draw(WIDTH/2-@background_image.width/2, HEIGHT/2-@background_image.height/2, 0)
    
    @ball.draw(self)

    @left_paddle.draw(self)
    @right_paddle.draw(self)

    @font.draw(@left_score, 30, 30, 0)
    @font.draw(@right_score, WIDTH-50, 30, 0)
  end

  def button_down(button)
    case button
      when Gosu::KbEscape
        close
      else
        # do nothing
    end
  end
end

Game.run