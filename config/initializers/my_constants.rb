if Rails.env.production?
  SUBURI = "/by"
else
  SUBURI = ''
end