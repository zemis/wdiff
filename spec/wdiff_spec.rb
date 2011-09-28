require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Wdiff" do
  context "On String Instance" do
    it "should return the diff with another string" do
      'this is a test'.wdiff('this is another test').should == 'this is [-a-] {+another+} test'
    end
    
    it "should allow overriding the delete regions" do
      'this is a test'.wdiff('this is another test', :deletes => ["<del>", "</del>"]).should == 'this is <del>a</del> {+another+} test'
    end
    
    it "should allow overriding the insert regions" do
      'this is a test'.wdiff('this is another test', :inserts => ["<ins>", "</ins>"]).should == 'this is [-a-] <ins>another</ins> test'
    end

  end

  context "Library" do
    it "should cope with nil strings" do
      Wdiff.diff(nil, nil).should == ""
    end
    
    it "should not fail when double quote are entered for inserts" do
      'this is a test'.wdiff('this is another test', :inserts => ["\"", "\""]).should == 'this is [-a-] "another" test'
      'this is a test'.wdiff('this is another test', :inserts => ['"', '"']).should == 'this is [-a-] "another" test'
    end
    
    it "should ignore unnecessary tokens for inserts" do
      'this is a test'.wdiff('this is another test', :inserts => ['"', "'", 'dddd']).should == "this is [-a-] \"another' test"
    end


    it "should not fail when double quote are entered for deletes"  do
      'this is a test'.wdiff('this is another test', :deletes => ["\"", "\""]).should == 'this is "a" {+another+} test'
      'this is a test'.wdiff('this is another test', :deletes => ['"', '"']).should == 'this is "a" {+another+} test'
    end
    
    it "should ignore unnecessary tokens for deletes" do
      'this is a test'.wdiff('this is another test', :deletes => ['"', "'", 'dddd']).should == "this is \"a' {+another+} test"
    end
  end
  
  context "Helper" do
    it "should return the HTML diff of two strings" do
      Wdiff::Helper.to_html('this is a test','this is another test').should == 'this is <del>a</del> <ins>another</ins> test'
    end
  end

  it "should raise error if xdiff is not in $PATH" do
    Wdiff.stub(:bin_path).and_return('wdiff2')
    lambda { Wdiff.verify_wdiff_in_path }.should raise_error
  end
end
