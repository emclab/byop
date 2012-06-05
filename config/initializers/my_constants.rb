if Rails.env.production?
  SUBURI = "/by"
else
  SUBURI = ''
end
#set session timeout minutes
SESSION_TIMEOUT_MINUTES = 90
SESSION_WIPEOUT_HOURS = 12