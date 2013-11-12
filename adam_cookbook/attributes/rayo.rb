default['adam']['rayo']['listeners'] = [
  {
    'type' => "c2s",
    'port' => "5222",
    'address' => "$${rayo_ip}",
    'acl' => ""
  },
  {
    'type' => "c2s",
    'port' => "5222",
    'address' => "127.0.0.1",
    'acl' => ""
  }
]
