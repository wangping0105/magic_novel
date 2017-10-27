class Attachment < ActiveRecord::Base
	belongs_to :attachmentable, polymorphic: true

	has_attached_file :file, {
		url: "/system/attachments/:hash.:extension",
		hash_secret: 'wangping&wangling'
	}
	do_not_validate_attachment_file_type :file
	validates_with AttachmentSizeValidator, attributes: :file, less_than: 10.megabytes

	has_attached_file :image, {
      styles: { medium: "300x300>", thumb: "100x100>" },
			url: "/system/images/:hash.:extension",
			hash_secret: 'wangping&wangling'
  }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
	validates_with AttachmentSizeValidator, attributes: :file, less_than: 5.megabytes

  def is_image?
		file_content_type =~ /\Aimage\/.*\z/
	end
end