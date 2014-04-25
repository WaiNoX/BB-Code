require 'bb_parser/tag_parser'

describe 'TagParser' do
  
  before(:all) do
    @tags_all = [:b, :i, :u, :s, :sub, :sup, :mail, :color, :font, :align, :quote, :img, :url, :list, :li, :table, :tr, :td, :th, :size]
    @tags_in_all = [:b, :i, :u, :s, :sub, :sup, :mail, :color, :font, :align, :quote, :img, :url, :list, :table, :size]
    @tags_allow_all = [:b, :i, :u, :s, :sub, :sup, :color, :font, :align, :quote, :size]
    @tags_allow_specific = [:tr, :td, :th, :li]
    @tags_allows_none = [:mail, :img, :url]
  end
  
  it "should accept correct tags" do
    TagParser.is_tag("[asdfg]").should be_true
    TagParser.is_tag("[aert=sdfg]").should be_true
    TagParser.is_tag("[aert='sdfg']").should be_true
    TagParser.is_tag("[aert=\"sdfg\"]").should be_true
  end
  
  it "should reject false tags" do
    TagParser.is_tag("[]").should be_false #leere tags gibts nicht
    TagParser.is_tag("[ ]").should be_false #leere tags gibts nicht
    TagParser.is_tag("[ä]").should be_false # tagnamen bestehen nur aus a-z
    TagParser.is_tag("[aert=]").should be_false #leeres argument gibts nicht
    TagParser.is_tag("[aert='']").should be_false 
    TagParser.is_tag("[aert=\"\"]").should be_false
    TagParser.is_tag("[aert=\"<\"]").should be_false # < ist im argument nicht erlaubt
    TagParser.is_tag("[aert=\"'\"]").should be_false # ' ist im argument nicht erlaubt
    TagParser.is_tag("[aert=\"\"\"]").should be_false # " ist im argument nicht erlaubt
    TagParser.is_tag("").should be_false #offensichtlich
    TagParser.is_tag("adsf").should be_false
    TagParser.is_tag("[a=[b]]").should be_false #tags wollen nicht so geschachtelt werden
  end
  
  it "should accept correct urls" do
    TagParser.is_url("www.wainox.de").should be_true
    TagParser.is_url("http://wainox.de").should be_true
    TagParser.is_url("ftp://wainox.de").should be_true
    TagParser.is_url("xyz://fooooo.bar").should be_true
  end
  
  it "should reject false urls" do
    TagParser.is_url("ww.wainox.de").should be_false
    TagParser.is_url("http:wainox.de").should be_false
    TagParser.is_url("ftp:/wainox.de").should be_false
    TagParser.is_url("xyz://fooooobar").should be_false
  end
  
  it "should parse open tag without attribute" do
    tag = TagParser.new '[name]'
    tag.closing?.should be_false
    tag.name.should eq 'name'
    tag.tag_name.should eq 'name'
    tag.get_data.should be_nil
    tag.original.should eq '[name]'
  end
  
  it "should parse open tag with \"attribute\"" do
    tag = TagParser.new '[name="attribute"]'
    tag.closing?.should be_false
    tag.name.should eq 'name'
    tag.tag_name.should eq 'name'
    tag.get_data.should eq 'attribute'
    tag.original.should eq '[name="attribute"]'
  end
  
  it "should parse open tag with 'attribute'" do
    tag = TagParser.new "[name=\'attribute\']"
    tag.closing?.should be_false
    tag.name.should eq 'name'
    tag.tag_name.should eq 'name'
    tag.get_data.should eq 'attribute'
    tag.original.should eq "[name='attribute']"
  end
  
  it "should parse close tag" do
    tag = TagParser.new "[/name]"
    tag.closing?.should be_true
    tag.name.should eq 'name'
    tag.tag_name.should eq 'name'
    tag.get_data.should be_nil
    tag.original.should eq "[/name]"
  end
  
  it 'should allow nesting when both allow all' do
    @tags_allow_all.each { |item| 
      tag = TagParser.new('['+item.to_s+']')
      @tags_in_all.each { |item2| 
        tag.allows?(item2).should be_true
      }
    }
  end
  
  it 'should allow nesting when they tolerate each other' do
    table = TagParser.new "[table]"
    table.allows?('tr').should be_true
    tr = TagParser.new "[tr]"
    tr.allows?('th').should be_true
    tr.allows?('td').should be_true
    list = TagParser.new "[list]"
    list.allows?('li')
  end
  
  it 'should not allow nesting if parrent forbids it' do
    @tags_allows_none.each { |item| 
      tag = TagParser.new('['+item.to_s+']')
      @tags_all.each { |item2| 
        tag.allows?(item2).should be_false
      }
    }
  end
  
  it 'should not allow nesting if child dosn\'t tolerate parent'do
    @tags_allow_all.each { |item| 
      tag = TagParser.new('['+item.to_s+']')
      @tags_allow_specific.each { |item2| 
        tag.allows?(item2).should be_false
      }
    }
  end
end

