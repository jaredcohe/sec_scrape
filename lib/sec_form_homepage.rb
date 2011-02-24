class SecFormHomepage
# sample link to a form page with links to the form => http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/0001439404-10-000003-index.htm

  attr_accessor(:xml_form_body_link, :html_form_body_link)

  def initialize(form_homepage_link)
    form_homepage = Nokogiri::XML(open(form_homepage_link)).remove_namespaces!
    xml_link_to_pull_data_from = form_homepage.xpath("//td[a='primary_doc.xml']//@href").text
    html_form_link_to_return = form_homepage.xpath("//td[a='primary_doc.html']//@href").text
    @html_form_body_link = "http://www.sec.gov" + html_form_link_to_return
    @xml_form_body_link = "http://www.sec.gov" + xml_link_to_pull_data_from
  end

end
