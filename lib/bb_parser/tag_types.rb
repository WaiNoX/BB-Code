class TagTypes
  
  @@tags = {
    :b => {
      :name => 'b',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :i => {
      :name => 'i',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :u => {
      :name => 'u',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :sub => {
      :name => 'sub',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :sup => {
      :name => 'sup',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :mail => {
      :name => 'mail',
      :allows_all_tags => false,
      :allowed_tags => [],
      :handler => 'MailTag'
    },
    :color => {
      :name => 'color',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'ColorTag'
    },
    :font => {
      :name => 'font',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'FontTag'
    },
    :align => {
      :name => 'align',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'AlignTag'
    },
    :quote => {
      :name => 'quote',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'QuoteTag'
    },
    :img => {
      :name => 'img',
      :allows_all_tags => false,
      :allowed_tags => [],
      :handler => 'ImgTag'
    },
    :url => {
      :name => 'url',
      :allows_all_tags => false,
      :allowed_tags => [],
      :handler => 'UrlTag'
    },
    :list => {
      :name => 'list',
      :allows_all_tags => false,
      :allowed_tags => ['li'],
      :handler => 'ListTag'
    },
    :li => {
      :name => 'li',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :table => {
      :name => 'table',
      :allows_all_tags => false,
      :allowed_tags => ['tr'],
      :handler => 'TableTag'
    },
    :tr => {
      :name => 'tr',
      :allows_all_tags => false,
      :allowed_tags => ['th', 'td'],
      :handler => 'SimpleTag'
    },
    :td => {
      :name => 'td',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :th => {
      :name => 'th',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SimpleTag'
    },
    :size => {
      :name => 'size',
      :allows_all_tags => true,
      :allowed_tags => [],
      :handler => 'SizeTag'
    }#,
#    :spoiler => {
#      :name => 'spoiler',
#      :allows_all_tags => true,
#      :allowed_tags => [],
#      :handler => 'SpoilerTag'
#    }
  }
  
  def self.get_info(tag)
    return @@tags[tag.to_sym]
  end
end