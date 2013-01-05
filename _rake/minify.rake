require "reduce"

source_dir  = "source"    # source file directory
public_dir  = "public"    # compiled site directory

desc "minifies static files"
task :minify do
  puts "## Compressing static assets"
  original = 0.0
  compressed = 0 
  Dir.glob("#{public_dir}/**/*.*") do |file|
    case File.extname(file)
      when '.html', '.css', '.xml'
        puts "processing: #{file}"
        original += File.size(file).to_f
        min = Reduce.reduce(file)
        File.open(file, "w") do |f|
          f.write(min)
        end
        compressed += File.size(file)
      else
        puts "skipping: #{file}"
      end
  end
  puts "Total compression %0.2f\%" % (((original-compressed)/original)*100)
end

desc "minifies static files"
task :minify_source do
  puts "## Compressing static assets"
  original = 0.0
  compressed = 0 
  Dir.glob("#{source_dir}/**/*.*") do |file|
    case File.extname(file)
      when '.js', '.png', '.jpg', '.jpeg', '.gif'
        puts "processing: #{file}"
        original += File.size(file).to_f
        min = Reduce.reduce(file)
        File.open(file, "w") do |f|
          f.write(min)
        end
        compressed += File.size(file)
      else
        puts "skipping: #{file}"
      end
  end
  puts "Total compression %0.2f\%" % (((original-compressed)/original)*100)
end