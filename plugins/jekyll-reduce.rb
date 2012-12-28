require 'reduce'
require 'html_press'

module Jekyll
  module Compressor
    def output_file(dest, content)
      FileUtils.mkdir_p(File.dirname(dest))
      File.open(dest, 'w') do |f|
        f.write(content)
      end
    end

    def compress(path, content)
      warn "processing: #{path}"
      self.output_file(path, Reduce.reduce(path))
    rescue Exception => e
      warn "parse error occurred while processing: #{path}"
      warn "details: #{e.message.strip}"
      warn "copying initial file"
      self.output_file(path, content)
    end
    
    def compress_html(path, content)
      warn "processing: #{path}"
      #self.output_file(path, HtmlPress.press(content))
      # html compression disabled
      self.output_file(path, content)
    rescue Exception => e
      warn "parse error occurred while processing: #{path}"
      warn "details: #{e.message.strip}"
      warn "copying initial file"
      self.output_file(path, content)
    end
  end

  class Post
    include Compressor

    def write(dest)
      dest_path = self.destination(dest)
      case File.extname(dest_path)
        when '.html'
          self.compress_html(dest_path, self.output)
        else
          # .txt and .rss
          self.output_file(dest_path, self.output)
      end
    end
  end

  class Page
    include Compressor

    def write(dest)
      dest_path = self.destination(dest)
      case File.extname(dest_path)
        when '.html'
          self.compress_html(dest_path, self.output)
        else 
          self.output_file(dest_path, self.output)
      end
    end
  end

  class StaticFile
    include Compressor
    
    def copy_file(path, dest_path)
      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.cp(path, dest_path)
    end

    def write(dest)
      dest_path = self.destination(dest)

      return false if File.exist?(dest_path) and !self.modified?
      @@mtimes[path] = mtime

      case File.extname(dest_path)
        when '.js'
          self.copy_file(path, dest_path)
          self.compress(dest_path, File.read(path))
        when '.css'
          self.copy_file(path, dest_path)
          self.compress(dest_path, File.read(path))
        when '.png'
          self.copy_file(path, dest_path)
          self.compress(dest_path, File.read(path))
        when '.jpg'
          self.copy_file(path, dest_path)
          self.compress(dest_path, File.read(path))
        when '.jpeg'
          self.copy_file(path, dest_path)
          self.compress(dest_path, File.read(path))
        when '.gif'
          self.copy_file(path, dest_path)
          self.compress(dest_path, File.read(path))
        else
          copy_file(path, dest_path)
      end

      true
    end
  end
end