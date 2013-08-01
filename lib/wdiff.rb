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

      options[:inserts].each_with_index do |token, index|
        token.gsub!(/^\"$/,'\"') if token == '"'
        parts << ( index.even? ?  %Q(--start-insert="#{token}")  :  %Q(--end-insert="#{token}") )
        break if index >= 1
      end if options[:inserts]

      
      options[:deletes].each_with_index do |token, index|
        token.gsub!(/^\"$/,'\"') if token == '"'
        parts << ( index.even? ?  %Q(--start-delete="#{token}")  :  %Q(--end-delete="#{token}") )
        break if index >= 1
      end if options[:deletes]
      
      parts.join(" ")
    end

    def diff(old_str, new_str, options={})
      f1, f2 = Tempfile.new('f1'), Tempfile.new('f2')
      f1.write(old_str); f1.flush
      f2.write(new_str); f2.flush
      opt_str = options_string_from_hash(options)
      %x{#{bin_path} #{opt_str} #{f1.path} #{f2.path}}
    ensure
      f1.close
      f1.unlink
      f2.close
      f2.unlink
    end
  end

  def wdiff(str_new, options={})
    Wdiff::diff(self, str_new, options)
  end

  module Helper
    def self.to_html(old_str,new_str)
      Wdiff::diff(old_str, new_str, :inserts => ["<ins>", "</ins>"], :deletes => ["<del>", "</del>"])
    end
  end
end

String.send(:include, Wdiff)
