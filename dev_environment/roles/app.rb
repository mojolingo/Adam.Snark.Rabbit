name "app"
description "Application Instance"
run_list "role[base]",
  "recipe[git]",
  "recipe[ruby_build]",
  "recipe[rbenv::system]",
  "recipe[postfix]",
  "recipe[adam]"
override_attributes 'rbenv' => {
  "global"  => "2.0.0-p0",
  "rubies"  => ["2.0.0-p0"],
  "gems" => {
    "2.0.0-p0" => [
      {"name" => "bundler"},
      {"name" => "foreman"}
    ]
  }
}
