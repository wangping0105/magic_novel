class DownLoadFile
  class << self

    def download(file_url, file_temp_path = nil)
      file = file_temp_path.present? ? Tempfile.new(file_temp_path): Tempfile.new
      file.binmode

      begin
        open(file_url) {|f|
          f.each_line {|line| file.write(line)}
        }

        file.flush
      rescue
        file.write(`curl #{file_url} `)
      end

      file
    end
  end
end
