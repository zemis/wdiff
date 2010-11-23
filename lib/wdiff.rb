require 'tempfile'
module Wdiff
  class << self
    def included(target)
      verify_wdiff_in_path
    end
    def verify_wdiff_in_path
      path = %x{which #{bin_path}}
      raise "GNU wdiff (http://www.gnu.org/software/wdiff/) not found in $PATH" if path.empty?
    end
    def bin_path
      'wdiff'
    end
  end

  def wdiff(str_new)
    f1, f2 = Tempfile.new('f1'), Tempfile.new('f2')
    f1.write(self); f1.flush
    f2.write(str_new); f2.flush
    raw = %x{#{Wdiff::bin_path} #{f1.path} #{f2.path}}
    f1.close; f2.close
    raw
  end
  
  module Helper
    def self.to_html(str)
      str.gsub(/\[\-/,'<del>').gsub(/\-\]/,'</del>').gsub(/\{\+/,'<ins>').gsub(/\+\}/,'</ins>')
    end
  end
end

String.send(:include, Wdiff)
