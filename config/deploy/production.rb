WEB1 = "34.231.133.189" # ELASTIC SPOT FLET WEB (c3.large)
server WEB1,
  user: "ubuntu",
  roles: %w{web db app}