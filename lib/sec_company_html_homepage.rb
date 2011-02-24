class SecCompanyHtmlHomepage
# getting data from the HTML homepage of the company on the SEC website
# HTML version: sample link to an SEC company homepage (form page with links to the form) => http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001439404&owner=exclude&count=40
# sample cik = 0001439404

  attr_accessor(:xml_page, :state_location, :state_incorporation, :legal_name)

  def initialize(cik)
    @link_to_company_html_page = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{cik}&owner=exclude&count=40"
    @xml_page = Nokogiri::XML(open(@link_to_company_html_page))
  end

  def get_data_from_company_html_page(xml_page)

    # pull legal name from form list page
    @legal_name_and_CIK_from_form_list_page = xml_page.xpath("//span[@class='companyName']").text
    @array_of_legal_name_and_more_from_form_list_page = @legal_name_and_CIK_from_form_list_page.split(" CIK#")
    @legal_name = @array_of_legal_name_and_more_from_form_list_page[0]

    # pull states of location and incorporation from form list page
    @states_from_form_list_page = xml_page.xpath("//*[@class='identInfo']").text
    if @states_from_form_list_page.include?("State of Inc.")
      @array_of_states_from_form_list_page = @states_from_form_list_page.split(" | ")
      @array_of_location_state_from_form_list_page = @array_of_states_from_form_list_page[0].split("State location: ")
      @array_of_inc_state_from_form_list_page = @array_of_states_from_form_list_page[1].split("State of Inc.: ")
      @state_location = @array_of_location_state_from_form_list_page[1]
      @state_incorporation = @array_of_inc_state_from_form_list_page[1]
    else
      @state_location = @states_from_form_list_page.split("State location: ")
    end
  end
end