module Commonable
  extend ActiveSupport::Concern

  included do
  end

  def save_request_logs(last_chapter_id: nil)
    ip = request.remote_ip

    request = RequestLog.where(ip: ip).last
    if request && request.time_diff_in
      request.with_lock do
        request.count += 1
        request.last_chapter_id = last_chapter_id if last_chapter_id.present?

        request.save!
      end
      request.count = request.count += 1
    else
      RequestLog.create(ip: ip, user_id: current_user.try(:id), last_chapter_id: last_chapter_id, count: 1)
    end
  end

  def fetch_memberchace(_cache_key, expires_in, &block)
    return yield if $dalli_store.nil?

    $dalli_store.read(_cache_key) || $dalli_store.fetch(_cache_key, expires_in: expires_in) do
      puts "存入membercache!"
      yield
    end
  end

  def set_direct_url_in_request
    session[:temp_redirect_url] = request.url
  end
end
