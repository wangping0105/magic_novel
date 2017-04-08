namespace :zhuangbbq do
  desc 'change_img_name'
  task :change_img_name  => :environment  do
    Attachment.find_each do |a|
      name = a.name
      change_image_name(name)

      # absoulte_path2 = "#{Rails.root.to_s}/public/zhuangbbq/emoticons_min/#{name}"
      # absoulte_path2_new = "#{Rails.root.to_s}/public/zhuangbbq/emoticons_min/#{new_name}"
      # `mv '#{absoulte_path2}' '#{absoulte_path2_new}'`

      # content = name.split("_").last.gsub(".#{prefix}","")
      # a.update(name: new_name, file_file_name: new_name, note: content)

      print "."
    end
  end

  task :change_img_name_file  => :environment  do
    Dir.entries("#{Rails.root.to_s}/public/zhuangbbq/emoticons").each do |name|
      change_image_name(name)

      print "."
    end
  end

  def change_image_name(name)
    prefix = name.split(".").last
    new_name = "#{name.split("_").first}.#{prefix}"
    absoulte_path1 = "#{Rails.root.to_s}/public/zhuangbbq/emoticons/#{name}"
    absoulte_path1_new = "#{Rails.root.to_s}/public/zhuangbbq/emoticons/#{new_name}"
    `mv '#{absoulte_path1}' '#{absoulte_path1_new}'`
  end

  desc '小图'
	task :extra_img  => :environment  do
    # FileUtils.mkdir_p "public/zhuangbbq/emoticons_min/"
    # Dir["public/zhuangbbq/emoticons/*.gif"].each_with_index{|path, i|
    #   absoulte_path = "#{Rails.root.to_s}/#{path}"
    #   resize_gif(absoulte_path)
    # }

    # Dir["public/zhuangbbq/emoticons_min/*.gif"].each_with_index{|path, i|
    #   absoulte_path = "#{Rails.root.to_s}/#{path}"
    #   resize_img(absoulte_path, type: "gif")
    # }
    # Dir["public/zhuangbbq/emoticons/*.jpg", "public/zhuangbbq/emoticons/*.png"].each_with_index{|path, i|
    #   absoulte_path = "#{Rails.root.to_s}/#{path}"
    #   resize_img(absoulte_path)
    # }

    Dir["public/zhuangbbq/emoticons/*.jpeg"].each_with_index{|path, i|
      absoulte_path = "#{Rails.root.to_s}/#{path}"
      resize_img(absoulte_path)
    }
  end

  task :delete_miss_img => :environment  do
    attachs = Attachment.where(name: %w(3113.gif 3252.gif  4133.gif 4711.gif 4079.gif 2464.gif 2574.gif 2076.gif 1244.jpeg))
    attachs.each do |a|
      absoulte_path = "#{Rails.root.to_s}/public/zhuangbbq/emoticons/#{a.name}"
      `rm #{absoulte_path}`
    end
    attachs.delete_all
    p "ok"
  end

  # gif 转化
  def resize_gif(absoulte_path)
    new_path = absoulte_path.gsub("emoticons/","emoticons_min/")
    unless File.exist? new_path
      begin
      `convert "#{absoulte_path}[0]" "#{new_path}"`
      rescue
        p new_path
      end
    end
  end

  def resize_img(absoulte_path, type: 'img')
    # f = File.new(absoulte_path)
    new_path = absoulte_path.gsub("emoticons/","emoticons_min/")
    unless File.exist? new_path
      begin
        img=if type == 'gif'
          MiniMagick::Image.open(new_path)
        else
          MiniMagick::Image.open(absoulte_path)
        end

        _size = img.size
        img.resize 150 if _size > 5000
        img.write new_path

        print "."
      rescue
        # 单个去删除还是
        # Attachment.where(name: absoulte_path.split("\/").last).delete_all
        # `rm #{absoulte_path}`
        puts "error & rm #{absoulte_path.split("\/").last}"
      end
    end
  end

	desc '下载图片'
	task :download  => :environment  do
		(209..7372).each do |i|
      do_a_img(i)
		end
  end

  def do_a_img(i, pass_exist: true)
    agent = Mechanize.new
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
        unless File.exists?("#{dir}/#{title}") && pass_exist
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

      "#{dir}/#{title}"
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