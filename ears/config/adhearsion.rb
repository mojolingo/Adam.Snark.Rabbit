# encoding: utf-8

$stdout.sync = true # Do not buffer stdout

Adhearsion.router do
  openended do
    route 'default' do
      answer
      speak "Hi, this is Adam. How can I help you?"

      invoke GatherInputController
    end
  end
end
