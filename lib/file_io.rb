require 'pry'
require_relative '../../complete_me_project/Complete_Me/lib/complete_me'

class FileIO

  def complete_me
    cm = CompleteMe.new
    cm.populate(File.read("/usr/share/dict/words"))
    cm
  end

end
