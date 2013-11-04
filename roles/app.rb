name "app"
description "Application Instance"
run_list "role[base]",
  "recipe[adam]"
override_attributes 'ruby_build' => {
  'upgrade' => 'sync'
}
