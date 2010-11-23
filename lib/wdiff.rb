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
    cmd = "bash -c '#{Wdiff::bin_path} <(echo \"#{self}\") <(echo \"#{str_new}\")'"
    raw = %x{#{cmd}}
    raw.chop unless raw.nil?
  end
  
  module Helper
    def self.to_html(str)
      str.gsub(/\[\-/,'<del>').gsub(/\-\]/,'</del>').gsub(/\{\+/,'<ins>').gsub(/\+\}/,'</ins>')
    end
  end
end

String.send(:include, Wdiff)
