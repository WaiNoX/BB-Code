class TagTypes
  
  @@tags = {
    :b => {
      :name => 'b',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SimpleTag'
    },
    :i => {
      :name => 'i',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SimpleTag'
    },
    :u => {
      :name => 'u',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SimpleTag'
    },
    :s => {
      :name => 's',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SimpleTag'
    },
    :sub => {
      :name => 'sub',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SimpleTag'
    },
    :sup => {
      :name => 'sup',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SimpleTag'
    },
    :mail => {
      :name => 'mail',
      :allows_all_tags => false,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'MailTag'
    },
    :color => {
      :name => 'color',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'ColorTag'
    },
    :font => {
      :name => 'font',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'FontTag'
    },
    :align => {
      :name => 'align',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'AlignTag'
    },
    :quote => {
      :name => 'quote',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'QuoteTag'
    },
    :img => {
      :name => 'img',
      :allows_all_tags => false,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'ImgTag'
    },
    :url => {
      :name => 'url',
      :allows_all_tags => false,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'UrlTag'
    },
    :list => {
      :name => 'list',
      :allows_all_tags => false,
      :allowed_tags => ['li'],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'ListTag'
    },
    :li => {
      :name => 'li',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => false,
      :allowed_in => ['list'],
      :handler => 'SimpleTag'
    },
    :table => {
      :name => 'table',
      :allows_all_tags => false,
      :allowed_tags => ['tr'],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'TableTag'
    },
    :tr => {
      :name => 'tr',
      :allows_all_tags => false,
      :allowed_tags => ['th', 'td'],
      :allowed_in_all => false,
      :allowed_in => ['table'],
      :handler => 'SimpleTag'
    },
    :td => {
      :name => 'td',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => false,
      :allowed_in => ['tr'],
      :handler => 'SimpleTag'
    },
    :th => {
      :name => 'th',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => false,
      :allowed_in => ['tr'],
      :handler => 'SimpleTag'
    },
    :size => {
      :name => 'size',
      :allows_all_tags => true,
      :allowed_tags => [],
      :allowed_in_all => true,
      :allowed_in => [],
      :handler => 'SizeTag'
    }#,
#    :spoiler => {
#      :name => 'spoiler',
#      :allows_all_tags => true,
#      :allowed_tags => [],
#      :allowed_in_all => true,
#      :allowed_in => [],
#      :handler => 'SpoilerTag'
#    }
  }
  
  def self.get_info(tag)
    return @@tags[tag.to_sym.downcase]
  end
end