class BtearCurrency < ApplicationRecord
  attr_accessor :rate

  validates_uniqueness_of :name

  def self.currency_names
    {
        :mec=>"美卡币MEC",
        :bts=>"比特股BTS",
        :hlb=>"活力币HLB",
        :xcn=>"氪石币XCN",
        :mgc=>"众合币MGC",
        :eac=>"地球币EAC",
        :xzc=>"零币XZC",
        :vash=>"微币VASH",
        :zcc=>"招财币ZCC",
        :btc=>"比特币BTC",
        :doge=>"狗狗币DOGE",
        :ltc=>"莱特币LTC",
        :ncs=>"资产股NCS",
        :xrp=>"瑞波币XRP",
        :qrk=>"夸克币QRK",
        :nxt=>"未来币NXT",
        :ardr=>"阿朵ARDR",
        :dgc=>"数码币DGC",
        :emc=>"崛起币EMC",
        :xem=>"新经币XEM",
        :ric=>"黎曼币RIC",
        :xlm=>"恒星币XLM",
        :xpm=>"质数币XPM",
        :wdc=>"世界币WDC",
        :src=>"安全币SRC",
        :blk=>"黑币BLK",
        :ppc=>"点点币PPC",
        :tag=>"悬赏币TAG",
        :bost=>"增长币BOST",
        :ybc=>"元宝币YBC",
        :bec=>"比奥币BEC",
        :dash=>"达世币DASH",
        :med=>"地中海MED",
        :anc=>"阿侬币ANC",
        :sys=>"系统币SYS",
        :tmc=>"时代币TMC"
    }
  end
end
