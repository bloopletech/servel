module Servel
  class MaxImageSizeRackFile < Rack::File
    IMAGE_EXTS = %w(.jpg .jpeg .png)

    def serving(request, path)
      if request.options?
        return [200, {'Allow' => ALLOW_HEADER, CONTENT_LENGTH => '0'}, []]
      end
      last_modified = ::File.mtime(path).httpdate
      return [304, {}, []] if request.get_header('HTTP_IF_MODIFIED_SINCE') == last_modified

      headers = { "Last-Modified" => last_modified }
      mime_type = mime_type path, @default_mime
      headers[Rack::CONTENT_TYPE] = mime_type if mime_type

      # Set custom headers
      @headers.each { |field, content| headers[field] = content } if @headers

      response = [ 200, headers ]

      if (max_size = request.get_header('HTTP_X_MAX_IMAGE_SIZE')) && IMAGE_EXTS.include?(::File.extname(path))
        image = resize_image(path, max_size.to_i)
        if image
          response[2] = [image]
          return response
        end
      end

      size = filesize path

      range = nil
      ranges = Rack::Utils.get_byte_ranges(request.get_header('HTTP_RANGE'), size)
      if ranges.nil? || ranges.length > 1
        # No ranges, or multiple ranges (which we don't support):
        # TODO: Support multiple byte-ranges
        response[0] = 200
        range = 0..size-1
      elsif ranges.empty?
        # Unsatisfiable. Return error, and file size:
        response = fail(416, "Byte range unsatisfiable")
        response[1]["Content-Range"] = "bytes */#{size}"
        return response
      else
        # Partial content:
        range = ranges[0]
        response[0] = 206
        response[1]["Content-Range"] = "bytes #{range.begin}-#{range.end}/#{size}"
        size = range.end - range.begin + 1
      end

      response[2] = [response_body] unless response_body.nil?

      response[1][Rack::CONTENT_LENGTH] = size.to_s
      response[2] = make_body request, path, range
      response
    end

    def resize_image(path, max_dimension)
      img = Magick::Image.read(path).first

      return nil if img.columns <= max_dimension && img.rows <= max_dimension

      img.change_geometry!("#{max_dimension}x#{max_dimension}") { |cols, rows, _img| _img.resize!(cols, rows) }
      img.page = Magick::Rectangle.new(img.columns, img.rows, 0, 0)

      img.to_blob
    rescue Exception => e
      puts "There was an error generating image: #{e.inspect}"
      return nil
    end
  end
end