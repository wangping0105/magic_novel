class ImportWorker
  include Sidekiq::Worker
  require 'csv'
  DefaultPath = "#{Rails.root.to_s}/public/books"

  def perform(opts = {})

  end

end