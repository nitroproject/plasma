require 'test/unit'

require 'glue/greek/greeklish'

class TC_Greeklish < Test::Unit::TestCase # :nodoc: all
  
  def test_mappings
    assert_equal 'ti egine re paidia', 'τι έγινε ρε παιδιά'.to_greeklish
    assert_equal 'pswmi + nero 1', 'ψωμί + νερό 1'.to_greeklish
  end
    
end
