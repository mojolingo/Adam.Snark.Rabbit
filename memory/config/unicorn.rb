worker_processes ENV["RAILS_ENV"] == "development" ? 1 : 3

timeout 30
