if Rails.env.production?
  SUBURI = "/by"
else
  SUBURI = ''
end
#set session timeout minutes
SESSION_TIMEOUT_MINUTES = 90
SESSION_WIPEOUT_HOURS = 12
DAYS_OF_NEW = 7  #mark for view within DAYS_OF_NEW