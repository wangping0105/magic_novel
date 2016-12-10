namespace :zhuangbbq do
	desc ''
	task  :download  => :environment  do
		agent = Mechanize.new
		(209..7372).each do |i|
			puts "http://www.zhuangbbq.com/emotions/#{i}"
			page = nil
			try_request_and_time(5, 10) do
				page = agent.get("http://www.zhuangbbq.com/emotions/#{i}")
			end

			if page.present?
				dir = "#{Rails.root.to_s}/public/zhuangbbq/emoticons"
				FileUtils.mkdir_p(dir) unless File.exists?(dir)

				img = page.search(".//*[@class='emotion-show']/img")
				if img
					url = img.first.attributes["src"].value
					url = "http://www.zhuangbbq.com#{url}" unless url.match("^http://image.zhuangbbq.com")
					postfix = url.split(".").last
					title = "#{i}_#{img.first.attributes["title"].value}.#{postfix}"
					unless File.exists?("#{dir}/#{title}")
						file = nil
						try_request_and_time(5, 10) do
							file = DownLoadFile.download(url, "#{dir}/#{title}")
            end
            if file
							Attachment.create(
                file_file_size: file.size,
								file_content_type: "image/#{postfix}",
								name: title,
								file_file_name: title,
								attachmentable_type: "Emoticon"
              )
            end

						puts "#{title}! "
					else
						puts "pass #{title}"
					end
				end
				sleep 0.1
			end
		end
	end

	def try_request_and_time(index, time, &block)
		i =0
		flag = false
		while( i < index && !flag)
			begin
				Timeout.timeout(time) do
					yield
					flag = true
				end
			rescue
				puts "\nthe #{i+1}times timeout and sleep 1s"
				sleep(1)
				i += 1
			end
		end
	end
end