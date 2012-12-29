require 'reduce'

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
      # Copies the original file over and compresses it
      self.output_file(path, content)
      self.output_file(path, Reduce.reduce(path))
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
        when '.html', '.xml'
          self.compress(dest_path, self.output)
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
        when '.html', '.xml'
          self.compress(dest_path, self.output)
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
        when '.js', '.css', '.png', '.jpg', '.jpeg', '.gif', '.xml'
          self.compress(dest_path, File.read(path))
        else
          copy_file(path, dest_path)
      end

      true
    end
  end
end