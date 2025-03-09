# frozen_string_literal: true

require "net/http"
require 'base64'

module Jekyll
  module SimpleIcons
    class SimpleIconsTag < Liquid::Tag
      def initialize(tag_name, markup, options)
        super
        # Split the markup into icon name and opts
        if markup =~ /^([^\s]+)\s*(.+)?$/
          @icon_slug = $1.strip.downcase
          @opts = {}
          if $2
            $2.scan(/(\w+):\s*([^\s,]+)/) do |key, value|
              @opts[key] = value
            end
          end
        else
          raise SyntaxError, "Syntax Error in 'simpleicons' - Valid syntax: simpleicons icon-name [key:value]"
        end
      end

      def get_icon_url(opts)
        color = @opts&.fetch('color', 'black') || 'black'  # default to black
        dark_color = @opts&.fetch('dark', nil) || nil  # default not to use dark color

        if dark_color.nil?
          "https://cdn.simpleicons.org/#{@icon_slug}/#{color}"
        else
          "https://cdn.simpleicons.org/#{@icon_slug}/#{color}/#{dark_color}"
        end
      end

      def download_icon(url)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.open_timeout = 5  # 5 seconds timeout for connection
        http.read_timeout = 5  # 5 seconds timeout for reading

        request = Net::HTTP::Get.new(uri)
        response = http.request(request)

        if response.code == "200"  # net/http returns http status code as string
          response.body
        else
          raise Net::HTTPError.new("Cannot fetch icon from #{url}, got HTTP #{response.code}", response)
        end
      end

      def svg_to_img_tag(svg_xml, height, width)
        # Strip whitespace and newlines to make the SVG more compact
        svg_xml = svg_xml.gsub(/\s+/, ' ').strip
        # Encode SVG to Base64
        base64_svg = Base64.strict_encode64(svg_xml)
        # Create the img tag with data URI
        "<img height=\"#{height}\" width=\"#{width}\" src=\"data:image/svg+xml;base64,#{base64_svg}\" alt=\"#{@icon_slug} simple-icon\">"
      end

      def render(context)
        height = @opts&.fetch('h', '32') || @opts&.fetch('height', '32') || '32'
        width = @opts&.fetch('w', '32') || @opts&.fetch('width', '32') || '32'

        begin
          url = get_icon_url(@opts)
          svg_xml = download_icon(url)
          img_tag = svg_to_img_tag(svg_xml, height, width)
          return %Q[#{img_tag}]

        rescue SocketError, Net::OpenTimeout, Net::ReadTimeout
          Jekyll.logger.error "[jekyll-simple-icons] Error: Cannot fetch icon from #{url}, connection timeout"

        rescue Net::HTTPError => e
          Jekyll.logger.error "[jekyll-simple-icons] Error: #{e.message}"

        rescue StandardError => e
          Jekyll.logger.error "[jekyll-simple-icons] Error: #{e.message}"
        end
        return ""

      end
    end
  end
end

Liquid::Template.register_tag("simpleicons", Jekyll::SimpleIcons::SimpleIconsTag)
