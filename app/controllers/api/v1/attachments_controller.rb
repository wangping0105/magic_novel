class Api::V1::AttachmentsController < Api::V1::BaseController

  def index

  end

  # params do
  #   requires :attachment, type: Hash do
  #     requires :file, type: Hash do
  #       optional :filename
  #       optional :type
  #       optional :headers
  #       optional :tempfile
  #     end
  #   end
  # end
  def upload
    permitted_params = params[:attachment]
    file = permitted_params.delete(:file)
    attr = {file: file, user: current_user}

    if permitted_params[:attachmentable_type].present? && permitted_params[:attachmentable_id].present?
      attachmentable_type = permitted_params[:attachmentable_type]
      attachmentable_id = permitted_params[:attachmentable_id]
      attr = attr.merge(attachmentable_type: attachmentable_type, attachmentable_id: attachmentable_id)
    end

    attachment = Attachment.create(attr)
    render json:{
      code: 0,
      data: AttachmentSerializer.new(attachment)
    }
  end

  # params do
  #   requires :attachments, type: Hash
  # end
  def multi_upload
    authenticate!
    attachments = []
    (attachment_params[:attachments] || []).each do |key, value|
      if value[:file]
        attachment = value[:file]
        attachment_params = {
          :filename => attachment[:filename],
          :type => attachment[:type],
          :headers => attachment[:head],
          :tempfile => attachment[:tempfile]
        }
        file = ActionDispatch::Http::UploadedFile.new(attachment_params)
        attachments << Attachment.create(file: file, user: current_user)
      end
    end
    {
      code: 0,
      data: attachments
    }
  end
end
