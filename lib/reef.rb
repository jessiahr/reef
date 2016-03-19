require "reef/version"
require "view_helpers/reef_helper"

module Reef
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

ActionView::Base.send :include, ReefHelper
