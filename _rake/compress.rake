require 'reduce'
require 'html_press'

Rake::Minify.new(:minify_and_combine) do
  files = FileList.new("#{public_dir}/*.*")

  puts "BEGIN Minifying #{output_file}"
  group(output_file) do
    files.each do |filename|
      puts "Minifying- #{filename} into #{output_file}"
      if filename.include? '.min.js'
        add(filename, :minify => false)
      else
        add(filename)
      end
    end
  end
  puts "END Minifying #{output_file}"
end