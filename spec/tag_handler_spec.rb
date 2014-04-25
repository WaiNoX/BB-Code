# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'bb_parser/tag_handler'
require 'bb_parser/tag_parser'

describe 'SimpleTag' do

  it "should output simple tags correct" do
    SimpleTag.parse_to_html(TagParser.new('[text]'), "more_text").should eq '<text>more_text</text>'
  end
end

describe 'FailTag' do
  it "should output unknown tags correct" do
    FailTag.parse_to_html(TagParser.new('[text="garden"]'), "more_text").should eq '[text=&quot;garden&quot;]more_text[/text]' # es wird escaped!!
  end
end
  
describe 'MailTag' do
  it "should output mail tags correct" do
    MailTag.parse_to_html(TagParser.new('[mail]'), "e@mail.com").should eq '<a href="mailto:e@mail.com">e@mail.com</a>'
    MailTag.parse_to_html(TagParser.new('[mail=e@mail.com]'), "description").should eq '<a href="mailto:e@mail.com">description</a>'
  end
end

describe 'ColorTag' do
  it 'should output color tags correct' do
    ColorTag.parse_to_html(TagParser.new('[color]'), 'text').should eq FailTag.parse_to_html(TagParser.new('[color]'), 'text') #farbe vergessen
    ColorTag.parse_to_html(TagParser.new('[color=12]'), 'text').should eq FailTag.parse_to_html(TagParser.new('[color=12]'), 'text') #farbe falsch
    ColorTag.parse_to_html(TagParser.new('[color=green]'), 'text').should eq '<span style="color:green">text</span>' #farbe als text
    ColorTag.parse_to_html(TagParser.new('[color=#A1B2C3]'), 'text').should eq '<span style="color:#A1B2C3">text</span>' #farbe als hex
  end
end

describe 'FontTag' do
  it 'should output font tags corect' do
    FontTag.parse_to_html(TagParser.new('[font]'), 'text').should eq FailTag.parse_to_html(TagParser.new('[font]'), 'text') #schrift vergessen
    FontTag.parse_to_html(TagParser.new('[font=2s123]'), 'text').should eq FailTag.parse_to_html(TagParser.new('[font=2s123]'), 'text') #schrift falsch, da nur a-z erlaubt
    FontTag.parse_to_html(TagParser.new('[font=Arial]'), 'text').should eq '<span style="font-family:Arial">text</span>' #farbe als text
  end
end

describe 'AlignTag' do
  it 'should output align tags corect' do
    AlignTag.parse_to_html(TagParser.new('[align]'), 'text').should eq FailTag.parse_to_html(TagParser.new('[align]'), 'text') #align vergessen
    AlignTag.parse_to_html(TagParser.new('[align=asdfg]'), 'text').should eq FailTag.parse_to_html(TagParser.new('[align=asdfg]'), 'text') #align falsch, da nur center, left right erlaubt
    AlignTag.parse_to_html(TagParser.new('[align=left]'), 'text').should eq '<div style="text-align:left">text</div>' #left
    AlignTag.parse_to_html(TagParser.new('[align=center]'), 'text').should eq '<div style="text-align:center">text</div>' #center
    AlignTag.parse_to_html(TagParser.new('[align=right]'), 'text').should eq '<div style="text-align:right">text</div>' #right
  end
end


describe 'QuoteTag' do
  it 'should output quote tags correct' do
    QuoteTag.parse_to_html(TagParser.new('[quote]'), 'childtext').should eq '<fieldset><blockquote>childtext</blockquote></fieldset>'
    QuoteTag.parse_to_html(TagParser.new('[quote=origin]'), 'childtext').should eq '<fieldset><legend>origin</legend><blockquote>childtext</blockquote></fieldset>'
  end
end

describe 'ImgTag' do
  it 'should output image tags correct' do
    ImgTag.parse_to_html(TagParser.new('[img]'), 'path/to/img').should eq '<img src="path/to/img"/>' #ohne größenangabe
    ImgTag.parse_to_html(TagParser.new('[img=sa45d]'), 'path/to/img').should eq FailTag.parse_to_html(TagParser.new('[img=sa45d]'), 'path/to/img') #falsche größenangabe
    ImgTag.parse_to_html(TagParser.new('[img=50x345]'), 'path/to/img').should  eq '<img src="path/to/img" width="50" height="345"/>' #absolute größenangabe
    ImgTag.parse_to_html(TagParser.new('[img=50%]'), 'path/to/img').should  eq '<img src="path/to/img" width="50%" height="50%"/>' #relative größenangabe
  end
end

describe 'UrlTag' do
  it 'should output url tags correct' do
    UrlTag.parse_to_html(TagParser.new('[url]'), "google.com").should eq '<a href="google.com">google.com</a>'
    UrlTag.parse_to_html(TagParser.new('[url=google.com]'), "description").should eq '<a href="google.com">description</a>'
  end
end

describe 'ListTag' do
  it 'should output list tags correct' do
    ListTag.parse_to_html(TagParser.new('[list]'), 'childtext').should eq '<ul>childtext</ul>' #unsortierte liste
    ListTag.parse_to_html(TagParser.new('[list=1]'), 'childtext').should eq '<ol>childtext</ol>' #sortierte liste
  end
end

describe 'TableTag' do
  it 'should output table tag correct' do
    TableTag.parse_to_html(TagParser.new('[table]'), 'sometext').should eq '<table border="1">sometext</table>'
  end
end

describe 'SizeTag' do
  it 'should output size tag correct' do
    SizeTag.parse_to_html(TagParser.new('[size]'), 'sometext').should eq FailTag.parse_to_html(TagParser.new('[size]'), 'sometext') #größe fehlt
    SizeTag.parse_to_html(TagParser.new('[size=1s31]'), 'sometext').should eq FailTag.parse_to_html(TagParser.new('[size=1s31]'), 'sometext') #größe falsch
    SizeTag.parse_to_html(TagParser.new('[size=1234]'), 'sometext').should eq '<span style="font-size:1234px">sometext</span>'
  end
end

