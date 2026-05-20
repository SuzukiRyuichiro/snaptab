# app/helpers/icon_helper.rb
module IconHelper
  # Renders an icon partial from app/views/components/icons/*.
  #
  # @param name [String] the base name of the partial without underscore.
  # @param color [String] CSS color for the stroke. Defaults to currentColor.
  # @param stroke_width [Number] stroke width in pixels. Defaults to 1.5.
  # @param size [Integer] Tailwind size class suffix. Defaults to 6.
  #
  # Usage:
  #   <%= icon 'camera' %>
  #   <%= icon 'microphone', color: '#f00', stroke_width: 2, size: 8 %>
  def icon(name, color: "currentColor", stroke_width: 1.5, size: 6)
    render partial: "components/icons/#{name}", locals: {
      color: color,
      stroke_width: stroke_width,
      size: size
    }
  end
end
