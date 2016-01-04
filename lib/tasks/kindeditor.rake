namespace :kindeditor do
  desc "copy kindeditor into public folder"
  task :assets => :environment do
    puts "copying kindeditor into public/assets folder ..."
    dest_path = "#{Rails.root}/public/assets"
    FileUtils.mkdir_p dest_path
    FileUtils.cp_r "#{Rails.root.to_s}/vendor/assets/javascripts/kindeditor/", dest_path
  end
end