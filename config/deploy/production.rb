WEB1 = "34.205.75.32" # ELASTIC SPOT FLET WEB (c3.large)
server WEB1,
  user: "ubuntu",
  roles: %w{web db app}