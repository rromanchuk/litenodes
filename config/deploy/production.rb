WEB1 = "52.3.134.232" # ELASTIC SPOT FLET WEB (c3.large)
server WEB1,
  user: "ubuntu",
  roles: %w{web db app}