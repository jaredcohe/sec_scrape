class SecCompanyRssHomepage
# getting data from the RSS homepage of the company on the SEC website
# RSS version: sample link to an SEC company homepage (form page with links to the form) => http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001439404&type=&dateb=&owner=exclude&start=0&count=40&output=atom
# sample cik = 0001439404

  attr_accessor(:xml_page, :form_count, :form_title, :link_to_form_homepage, :filed_label_and_date_filed,
                :filed_date)

  def initialize(cik)
    # get form data from RSS page and append to array
    @cik_for_rss = cik.to_s.gsub(/^0+/,'')
    @link_to_rss = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{@cik_for_rss}&type=&dateb=&owner=exclude&start=0&count=40&output=atom"
    @xml_page = Nokogiri::XML(open(@link_to_rss)).remove_namespaces!
    @form_count = xml_page.xpath("//title").size - 1
  end

  def get_data_from_company_rss_homepage(form_number)
  # get the data from the RSS link
    @form_title = @xml_page.xpath("/feed/entry[#{form_number}]/title[1]").text
    @link_to_form_homepage = @xml_page.xpath("/feed/entry[#{form_number}]/link[1]/@href").text

    @summary_tag = xml_page.xpath("/feed/entry[#{form_number}]/summary[1]").text
    @filed_label_and_date_filed = @summary_tag[/Filed\:\S+\s\S+/]
    @filed_date = @filed_label_and_date_filed.gsub(/Filed\S+\s/,'')
  end
  
end
