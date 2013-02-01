name "app"
description "Application Instance"
run_list "role[base]",
  "recipe[git]",
  "recipe[ruby_build]",
  "recipe[rbenv::system]",
  "recipe[postfix]",
  "recipe[adam]"
override_attributes 'rbenv' => {
  "global"  => "1.9.3-p374",
  "rubies"  => ["1.9.3-p374"],
  "gems" => {
    "1.9.3-p374" => [
      {"name" => "rake"},
      {"name" => "bundler"},
      {"name" => "foreman"}
    ]
  }
}
