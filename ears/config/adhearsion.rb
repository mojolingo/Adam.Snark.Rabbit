# encoding: utf-8

$stdout.sync = true # Do not buffer stdout

Adhearsion.router do
  route 'default' do
    answer
    speak "Hi, this is Adam, but you can call me Mr Rabbit. I don't really do much yet, but it's nice to meet you anyway! Bye!"
    hangup
  end
end
