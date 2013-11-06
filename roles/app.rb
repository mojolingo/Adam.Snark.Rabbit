name "app"
description "Application Instance"
run_list "recipe[adam::base]",
  "recipe[adam]"
override_attributes 'ruby_build' => {
  'upgrade' => 'sync'
}
