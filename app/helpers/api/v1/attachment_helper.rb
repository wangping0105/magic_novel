module Api::V1::AttachmentHelper

  #文件作为附件创建 attachments 传值 { attachment:'sub_type'}
  def create_attachments_by(entity, attachments = {})
    attachments.each do |key, val|
      if params[key].present?
        attachments = Attachment.where(id: params[key])
        attachments.each do |attachment|
          temp_hash = {
              attachmentable_id: entity.id,
              attachmentable_type: entity.class.name,
              attachment_position: params[key].index(attachment.id.to_s),
              sub_type: val
          }
          attachment.update(temp_hash)
        end
      end
    end
  end

  #音频创建
  def create_audios_by(entity, attachments = {})
    attachments.each do |key, val|
      if params[key].present?
        Audio.where(id: params[key]).each do |audio|
          temp_hash = {
              audioable_id: entity.id,
              audioable_type: entity.class.name,
              sub_type: val
          }
          audio.update(temp_hash)
        end
      end
    end
  end

  #文件作为附件更新 destroy_all 是否删除没有的值params参数，默认是删除的
  def update_attachments_by(entity, attachments = {}, destroy_all = false)
    attachments.each do |key, val|
      if params.has_key?(key) || params[key].present? || destroy_all
        sql = val.blank? ? "sub_type = '' or sub_type is null" : ["sub_type = ?", val]
        Attachment.where(attachmentable_id: entity.id, attachmentable_type: entity.class.name).where(sql).update_all(attachmentable_id: nil, attachmentable_type: nil)

        attachments = Attachment.where(id: params[key])
        attachments.each do |attachment|
          temp_hash = {
              attachmentable_id: entity.id,
              attachmentable_type: entity.class.name,
              attachment_position: params[key].index(attachment.id.to_s),
              sub_type: val
          }
          attachment.update(temp_hash)
        end
      end
    end
  end

  #音频更新
  def update_audios_by(entity, attachments = {}, destroy_all = false)
    attachments.each do |key, val|
      if params.has_key?(key) || params[key].present? || destroy_all
        sql = val.blank? ? "sub_type = '' or sub_type is null" : ["sub_type = ?", val]
        Audio.where(audioable_id: entity.id, audioable_type: entity.class.name).where(sql).update_all(audioable_id: nil, audioable_type: nil)

        Audio.where(id: params[key]).each do |audio|
          temp_hash = {
              audioable_id: entity.id,
              audioable_type: entity.class.name,
              sub_type: val
          }
          audio.update(temp_hash)
        end
      end
    end
  end

  #音频附件destroy
  def destroy_audios_by(attachments = [])
    attachments.each do |key|
      Audio.where(id: params[key]).destroy_all
    end
  end

  #文件作为附件destroy
  def destroy_attachments_by(attachments = [])
    attachments.each do |key|
      Attachment.where(id: params[key]).each do |attachment|
        if attachment.destroy
        end
      end
    end
  end
end
