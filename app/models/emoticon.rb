class Emoticon
	class << self
		def all_emoticon(page = nil, per_page = nil)
			@all_emoticon = Attachment.where(attachmentable_type: 'Emoticon')
			@all_emoticon = @all_emoticon.page(page) if page 
			@all_emoticon = @all_emoticon.per(per_page) if per_page
			@all_emoticon
		end

		def path(img)
      "/zhuangbbq/emoticons/#{img.name}"
		end

		def min_path(img)
      "/zhuangbbq/emoticons_min/#{img.name}"
		end
	end
end