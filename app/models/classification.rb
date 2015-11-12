class Classification < ActiveRecord::Base
  # 武侠·仙侠 玄幻·奇幻 都市·言情 网游·科幻 推理·悬疑 历史·军事 恐怖·探险 同人·拓展 讽刺
  has_many :books

end
