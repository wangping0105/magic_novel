RuCaptcha.configure do
  # Number of chars, default: 4
  self.len = 4
  # Image font size, default: 45
  self.font_size = 45
  # Cache generated images in file store, this is config files limit, default: 100
  # set 0 to disable file cache.
  self.cache_limit = 100
end