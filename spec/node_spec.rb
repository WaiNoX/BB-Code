require 'bb_parser/node'

describe 'Node' do
  
  before(:each) do
    @tree = Node.new('', :master, nil)
  end

  it "master should have his data" do
    @tree.get_type.should eq :master
    @tree.get_parent.should be_nil
    @tree.get_text.should eq ""
    @tree.get_tag.should be_nil
    @tree.get_childs.empty?.should be_true
  end
  
  it "bode should have his data" do
    n1 = Node.new('n1', :text, @tree)
    n1.get_type.should eq :text
    n1.get_parent.should eq @tree
    n1.get_text.should eq "n1"
    n1.get_tag.should be_nil
    n1.get_childs.empty?.should be_true
  end
  
  it "should be able to append/get childs" do
    n1 = Node.new('n1', :text, @tree)
    n2 = Node.new('n2', :tag, @tree)
    @tree.add_child(n1)
    @tree.get_childs.length.should eq 1
    @tree.add_child(n2)
    @tree.get_childs.length.should eq 2
    @tree.get_childs[0].should eq n1
    @tree.get_childs[1].should eq n2
    n3 = Node.new('n3', :blaa, @tree)
    n2.add_child(n3)
    n2.get_childs.length.should eq 1
    n2.get_childs[0].should eq n3
  end
  
  it 'should parse text to tag when :tag is given' do
    n1 = Node.new('[blobb=bbolb]', :tag, @tree)
    n1.get_tag.should_not be_nil
    n1.get_tag.name.should eq 'blobb'
    n1.get_tag.get_data.should eq 'bbolb'
  end
  
end

