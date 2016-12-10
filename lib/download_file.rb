class DownLoadFile
  class << self

    def download(file_url, file_path = nil, is_temp_file = false)
      if is_temp_file
        file = file_path.present? ? Tempfile.new(file_path): Tempfile.new
      else
        file = file_path.present? ? File.new(file_path, 'w'): File.new
      end
      file.binmode

      begin
        open(file_url) {|f|
          f.each_line {|line| file.write(line)}
        }
      rescue
        file.write(`curl #{file_url} `)
      end
      file.flush

      file
    end
  end
end
