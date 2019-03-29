require_relative '../controllers/controller'

module ScenicRoute
  module UI
    ##
    # An element which can respond to clicks, and can change its image when the
    # mouse is hovered over it.
    #
    # Each element is its own controller, allowing it to independently receive
    # mouse events. However, it does not draw itself.
    class MouseElement < Controllers::Controller
      ##
      # @return [Entities::Point] The current location of this element's
      #   top-left corner.
      attr_accessor :point

      ##
      # @reutrn [Gosu::Image] The image which this element displays by default.
      attr_accessor :image

      ##
      # @return [Gosu::Image?] The image which this element displays when the
      #   mouse hovers over it.
      attr_accessor :image_hover

      ##
      # @return [Boolean] Whether this element is reacting to mouse events or 
      #   not. Note that an element will still receive clicks if not drawn, or 
      #   vice versa; drawing and enable state are entirely independent.
      attr_accessor :enabled
      alias enabled? enabled

      ##
      # @return [Array<Proc>] The procs which will run when this element is
      #   clicked.
      attr_accessor :click_handlers

      ##
      # Create a new mouse element.
      def initialize(point, image, image_hover=nil)
        super()
        @point = point
        @image = image
        @image_hover = image_hover
        @click_handlers = []
        @enabled = true

        puts "WARNING: different image size for hover on MouseElement" \
          unless images_safe?
      end

      ##
      # @return [Boolean] True if both the default image and hover image are
      #   the same dimensions. If this is not the case, behaviour may be
      #   unpredictable.
      def images_safe?
        image_hover.nil? ||
          (image.width == image_hover.width &&
            image.height == image_hover.height)
      end

      ##
      # Register a new click handler on this element. The click handler should
      # be passed as a block.
      #
      # @return [MouseElement] Itself; this method may be chained.
      def on_click(&block)
        click_handlers << block
        self
      end

      ##
      # Fire all click handlers on click.
      def button_down(id)
        click_handlers.each(&:call) if enabled? && id == Gosu::MS_LEFT &&
          within_bounds?(mouse_point)
      end

      ##
      # Determines whether a point is within the bounds of this mouse element's
      # default image.
      # 
      # @param [Entities::Point] query_point
      # @return [Boolean]
      def within_bounds?(query_point)
        query_point.x >= point.x && query_point.x <= point.x + image.width &&
          query_point.y >= point.y && query_point.y <= point.y + image.height
      end

      ##
      # @returns [Boolean] True if the mouse is over this element.
      def hovering?
        within_bounds?(mouse_point)
      end

      ##
      # Draws the appropriate image for this element to the screen. Passes
      # varargs to Gosu's Image draw method, after x and y.
      def draw_element(*args)
        image_to_draw = hovering? && !image_hover.nil? ? image_hover : image
        image_to_draw.draw(point.x, point.y, *args)
      end
    end
  end
end