require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Wdiff" do
  it "should return the string diff of two strings" do
    'this is a test'.wdiff('this is another test').should == 'this is [-a-] {+another+} test'
  end

  it "should return the HTML diff of two strings" do
    Wdiff::Helper.to_html('this is a test'.wdiff('this is another test')).should == 'this is <del>a</del> <ins>another</ins> test'
  end

  it "should raise error if xdiff is not in $PATH" do
    Wdiff.stub(:bin_path).and_return('wdiff2')
    lambda { Wdiff.verify_wdiff_in_path }.should raise_error
  end
end
