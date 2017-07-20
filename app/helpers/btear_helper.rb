module BtearHelper
  def cacl_rate first, second
    ((first - second) * 100/second).round(2)
  end
end