require_relative 'game'

##
# The Scenic Route game.
module ScenicRoute
  ##
  # The core model classes of the game. This vary from huge, drawable objects
  # like {Entities::Map} to simple data containers like {Entities::Point}.
  # Basically, anything which contains data but doesn't fit cleanly into 
  # another module goes here.
  module Entities end

  ##
  # Contains static classes which facilitate gameplay elements, such as score
  # calculation.
  module Gameplay end

  ## 
  # Contains classes which perform or facilitate loading, saving, and
  # memoisation of non-local assets, such as those on disc.
  module IO end

  ##
  # The tile set system. Handles loading and memoisation of tile sets which are
  # used primarily to draw {Entities::Map} instances.
  module Tiles end

  ##
  # Contains classes which draw HUD elements, menus, non-essential gameplay
  # items, or anything else loosely graphical. This mostly houses the
  # controller architecture, which is extensively used throughout this codebase.
  module UI end
end

ScenicRoute::Game.new.show