WEB1 = "54.208.195.206" # ELASTIC SPOT FLET WEB (c3.large)
server WEB1,
  user: "ubuntu",
  roles: %w{web db app}