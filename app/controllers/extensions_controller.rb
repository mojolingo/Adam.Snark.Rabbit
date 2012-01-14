class ExtensionsController < Adhearsion::CallController
  def run
    answer
    
    puts call.inspect
  end
end