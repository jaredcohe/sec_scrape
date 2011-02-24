require 'test/unit'
require 'test_helper'

class SecScraperTest < Test::Unit::TestCase
  def setup
    @guid = "16156791365190141"
    @cik = "0001138344"
  
  end

  def test_cik_output    
    xml_page = prepare_rss_page(@cik)
    assert xml_page.xpath("//title[1]").text.include?(@cik)
  end

end