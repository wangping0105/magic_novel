# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Classification.delete_all
Book.delete_all

u = User.create(email: "admin@mb.com", admin: true, name: 'admin', password: '111111')
current_author = Author.create(user_id: u.id, name: u.name)

classification_names = %w(武侠 仙侠 玄幻 奇幻 都市 言情 网游 科幻 推理 悬疑 历史 军事 恐怖 探险 同人 拓展 讽刺 其他)
classification_names.each do |name|
  Classification.create(name: name, pinyin: PinYin.of_string(name).join(""))
end

Book.create(
  :title=>'测试书籍',
  :classification_id => Classification.first.id,
  :book_type => 0,
  :introduction=>'测试的用的',
  :remarks=> '测试备注',
  author_id: current_author.id
)

ChatRoom.create(name: '吐槽区', no: "#{Time.now.to_i}0001")
p '初始化成功'


(1..20).each do |index|
  Book.create(
    :title=>"测试书籍#{index}",
    :classification_id => Classification.find(index).id,
    :book_type => 0,
    :introduction=>' 简介：宁舒死翘翘了，又好运成了替苦逼炮灰逆袭的任务者。于是，宁舒在一个世界又一个世界中，扮演各种人生，遇到各种‘你无情，你冷酷，你无理取闹’的人。宁舒怒吼，你们这些渣渣，我只是来逆袭的，请不要妨碍我完成任务。穿越主角，重生主角，只有不努力的任务者，没有撬不掉的主角光环。宁舒不得不苦逼地',
    :remarks=> '测试备注',
    author_id: Author.first.id
  )
end