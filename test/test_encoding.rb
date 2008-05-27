require "test/unit"

require "idn_actionmailer"

class EncodingTest < Test::Unit::TestCase
  def setup
    @domains = [['مثال.إختبار', 'xn--mgbh0fb.xn--kgbechtv'],
                ['例子.测试', 'xn--fsqu00a.xn--0zwm56d'],
                ['例子.測試', 'xn--fsqu00a.xn--g6w251d'],
                ['παράδειγμα.δοκιμή', 'xn--hxajbheg2az3al.xn--jxalpdlp'],
                ['उदाहरण.परीक्षा', 'xn--p1b6ci4b4b3a.xn--11b5bs3a9aj6g'],
                ['例え.テスト', 'xn--r8jz45g.xn--zckzah'],
                ['실례.테스트', 'xn--9n2bp8q.xn--9t4b11yi5a'],
                ['пример.испытание', 'xn--e1afmkfd.xn--80akhbyknj4f'],
                ['உதாரணம்.பரிட்சை', 'xn--zkc6cc5bi7f6e.xn--hlcj6aya9esc7a'],
                ['blåbærgrød.dk', 'xn--blbrgrd-fxak7p.dk']]
  end
  
  def test_encoding
    @domains.each do |pair|
      assert_equal(pair[1], IdnActionmailer.encode(pair[0]))
    end
  end
end