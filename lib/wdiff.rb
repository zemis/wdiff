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

    # TODO - this will fail if option strings include quotes, need to escape quotes automagically
    def options_string_from_hash(options={})
      parts = []

      if options[:deletes]
        start_range, end_range = options[:deletes]
        parts << %Q(--start-delete="#{start_range}")
        parts << %Q(--end-delete="#{end_range}")
      end

      if options[:inserts]
        start_range, end_range = options[:inserts]
        parts << %Q(--start-insert="#{start_range}")
        parts << %Q(--end-insert="#{end_range}")
      end

      parts.join(" ")
    end

    def diff(old_str, new_str, options={})
      f1, f2 = Tempfile.new('f1'), Tempfile.new('f2')
      f1.write(old_str); f1.flush
      f2.write(new_str); f2.flush
      opt_str = options_string_from_hash(options)
      raw = %x{#{bin_path} #{opt_str} #{f1.path} #{f2.path}}
      f1.close; f2.close
      raw
    end
  end

  def wdiff(str_new, options={})
    Wdiff::diff(self, str_new, options)
  end

  module Helper
    def self.to_html(str)
      str.gsub(/\[\-/,'<del>').gsub(/\-\]/,'</del>').gsub(/\{\+/,'<ins>').gsub(/\+\}/,'</ins>')
    end
  end
end

String.send(:include, Wdiff)
