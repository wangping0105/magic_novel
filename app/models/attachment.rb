class Attachment < ActiveRecord::Base
	belongs_to :attachmentable, polymorphic: true

	has_attached_file :file, {
		url: "/system/attachments/:hash.:extension",
		hash_secret: 'wangping&wangling'
	}
	do_not_validate_attachment_file_type :file

		# validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  def is_image?
		file_content_type =~ /\Aimage\/.*\z/
	end
end