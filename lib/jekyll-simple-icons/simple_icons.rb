# frozen_string_literal: true

module Jekyll
  module SimpleIcons
    class SimpleIconsTag < Liquid::Tag
      def initialize(tag_name, markup, options)
        super
        # Split the markup into icon name and opts
        if markup =~ /^([^\s]+)\s*(.+)?$/
          @icon_slug = $1.strip
          if $2
            @opts = {}
            $2.scan(/(\w+):\s*([^\s,]+)/) do |key, value|
              @opts[key] = value
            end
          end
        else
          raise SyntaxError, "Syntax Error in 'simpleicons' - Valid syntax: simpleicons icon-name [key:value]"
        end
      end

      def render(context)
        height = @opts&.fetch('h', '32') || @opts&.fetch('height', '32') || '32'
        width = @opts&.fetch('w', '32') || @opts&.fetch('width', '32') || '32'
        color = @opts&.fetch('color', 'black') || 'black'  # default to black
        dark_color = @opts&.fetch('dark', nil) || nil  # default not to use dark color
        icon_slug = @icon_slug.downcase

        if dark_color.nil?
          %Q[
<img height="#{height}" width="#{width}" src="https://cdn.simpleicons.org/#{icon_slug}/#{color}" />
          ]
        else
          %Q[
<img height="#{height}" width="#{width}" src="https://cdn.simpleicons.org/#{icon_slug}/#{color}/#{dark_color}" />
          ]
        end

      end
    end
  end
end

Liquid::Template.register_tag("simpleicons", Jekyll::SimpleIcons::SimpleIconsTag)
