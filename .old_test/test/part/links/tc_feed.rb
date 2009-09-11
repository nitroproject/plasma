#$DBG = true

require 'test/unit'
require 'og'

require 'part/links/model/feed'

class TC_FeedSource < Test::Unit::TestCase # :nodoc: all

  def test_all
    $og = Og.start(
      :destroy => true,
      :adapter => :mysql,
      :name => 'test',
      :user => 'root'
    )

    s = FeedSource.create_with(
      :title => 'Anabubula',
      :url => 'http://anabubula.com/rss.xml'
    )
  end
  
end
