1.book_types
name
book_count
remarks
deleted_at
pinyin 


has_many :books

2.book 书籍表
title 标题
pinyin 标题拼音
author_id 关联作者（如果是转载作者创建一个不关联user_id的作者）
book_type 是否是原创作品0 还是转载1
introduction 简介
remarks 备注
tag_id  小说标签
classification_id  小说分类
status 未上线0  连载1  完结2
total_price 总价
discount 折扣
words  总字数
click_count 总点击
recommend_count 总推荐量
collection_count 总收藏量
book_volume_count 总卷数
book_chapter_count  总章节数
deleted_at是否删除

2.book_volumes 书籍卷数表
book_id
title (卷标题)
book_chapter_count  章节数
is_free 是否免费
price  一卷价格
discount 折扣
deleted_at

2.book_ chapters 书籍章节表
book_id（书籍id）
book_volume_id(卷数id)
title (章节标题)
content (内容)
next_chapter(下一章)
prev_chapter(上一章)
word_count 字数
is_free 是否可读  
types 类型 是否是置顶文章 默认不置顶0
price 章节单价
discount 折扣
deleted_at

############

3.authors 作者表
name 作者昵称（本站内唯一）
user_id
book_id
book_count 数量
level 作者等级
experience 经验
is_identity 是否通过认证
deleted_at

4 book_relations 计数表
book_id
user_id
relation_type （收藏， 关注）

5 book_day_click  每日点击
book_id
count 数量
day_date 日期


6 tags 表
id
name
pinyin
book_count
remark

7 book_tags  
tag_id
book_id

8 classification 书籍分类表
id
parent_id
name
pinyin
book_count
remark

9 book_marks  书签表
user_id
book_id
book_chapter_id
rails g model  BookMark user_id:integer book_id:integer book_chapter_id:integer


10 Notification 消息通知
title:string body:text user_id:integer subject_id:integer subject_type:string notify_type:integer status:integer path:string body_html:text category:integer extras:text receive_platform:integer













