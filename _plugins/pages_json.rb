require 'json'

class PagesJson < Liquid::Tag

  def initialize(tagName, args, tokens)
    super
  end

  def render(context)
    dump = []
    empty = ''.freeze
    for page in context.registers[:site].pages
      next if page['name'].end_with? '.scss'
      next if page['name'].end_with? '.css'
      next if page['name'].end_with? 'index.html'
      next if page['name'].end_with? '.json'

      title = page['name'].to_s
        .gsub('.html', empty)
        .gsub('.md', empty)
        .gsub('_', ' ')
      body = page['content'].to_s
        .gsub(/<script.*?<\/script>/m, empty)
        .gsub(/<!--.*?-->/m, empty)
        .gsub(/<style.*?<\/style>/m, empty)
        .gsub(/<.*?>/m, empty)
        .gsub(/\r?\n/, ' '.freeze)
        .gsub(/\s+/, ' '.freeze)

      dump.push({
        'title' => page['title'] || title,
        'url' => page['url'],
        'body' => body
      })
    end
    JSON[dump]
  end

  Liquid::Template.register_tag 'pages_json', self
end
