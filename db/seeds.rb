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

classification_names = %w(武侠 仙侠 玄幻 奇幻 都市 言情 网游 科幻 推理 悬疑 历史 军事 恐怖 探险 同人 拓展 讽刺)
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

p '初始化成功'
