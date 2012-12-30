require "reduce"

public_dir  = "public"    # compiled site directory

desc "minifies static files"
task :minify do
  Dir.glob("#{public_dir}/**/*.*") do |file|
    puts "## Compressing static assets"
    case File.extname(file)
        when '.html', '.js', '.css', '.png', '.jpg', '.jpeg', '.gif', '.xml'
          puts "processing: #{file}"
          total += File.size(file).to_f
          min = Reduce.reduce(file)
          File.open(file, "w") do |f|
            f.write(min)
          end
          puts "Compression: %0.2f\%" % (((original - File.size(file))/original)*100.0)
        end
  end
end