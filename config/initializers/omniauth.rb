Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, AppSettings.github_key, AppSettings.github_secret#, scope: "user, repo, gist"
end