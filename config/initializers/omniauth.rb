Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :kakao, "c1fbbaddeb906aad47efc9b59c11eacf"
  else
    provider :kakao, "1120cdc5280d18aee720bc31b274b1c4"
  end
end