# gems
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

# custom files for program
require 'lib/sec_company_rss_homepage'
require 'lib/sec_company_html_homepage'
require 'lib/sec_form_homepage'
require 'lib/sec_form_body'
# require 'lib/pull_from_database'

# to do
  # add database pulling
  # make tests

# run program: ruby <name of script> <name of file with guids and CIKs> (could add: > <name of output file>)
# for example: ruby sec_runner.rb test/test_data.csv (> results.csv if want an output file, but not used here)
# sample RSS link => http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=1439404&type=&dateb=&owner=exclude&start=0&count=40&output=atom
# sample link to list of forms page => http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001439404&owner=exclude&count=40
# sample link to a form page with links to the form => http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/0001439404-10-000003-index.htm
# sample link to the body of a form => http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/primary_doc.xml

# start with a CSV of guid and cik in that order
infile = ARGV[0]

# put guid and cik into an array of arrays
guid_cik_arrays = []
CSV.foreach(infile) {|r| guid_cik_arrays << r }

# array for final results
entities_array = []

# loop through each entity and add the data
guid_cik_arrays.each do |guid_cik_array|

  cik = guid_cik_array[1]

  # get form count
  company_rss_homepage_object = SecCompanyRssHomepage.new(cik)
  form_count = company_rss_homepage_object.form_count

  (1..form_count).each do |form_number|
    entity_hash = {}

    # add to hash: guid and cik from input file
    entity_hash[:guid] = guid_cik_array[0]
    entity_hash[:cik] = guid_cik_array[1]

    # add to hash from sec_form_rss_hompeage: form count, title of form, link to form homepage, and date filed
    # object is already instantiated from counting the forms
    company_rss_homepage_object.get_data_from_company_rss_homepage(form_number)
    entity_hash[:form_count] = form_count
    entity_hash[:form_title] = company_rss_homepage_object.form_title
    entity_hash[:link_to_form_homepage] = company_rss_homepage_object.link_to_form_homepage
    entity_hash[:filed_date] = company_rss_homepage_object.filed_date

    # add to hash from sec_company_html_homepage: legal name, state location, state incorporation
    company_html_homepage_object = SecCompanyHtmlHomepage.new(cik)
    xml_page_for_company_html = company_html_homepage_object.xml_page
    company_html_homepage_object.get_data_from_company_html_page(xml_page_for_company_html)
    entity_hash[:legal_name] = company_html_homepage_object.legal_name
    entity_hash[:state_location] = company_html_homepage_object.state_location
    entity_hash[:state_incorporation] = company_html_homepage_object.state_incorporation

    # add to hash from sec_form_homepage: xml_form_body_link
    form_homepage_object = SecFormHomepage.new(entity_hash[:link_to_form_homepage])
    entity_hash[:html_form_body_link] = form_homepage_object.html_form_body_link
    entity_hash[:xml_form_body_link] = form_homepage_object.xml_form_body_link

    # add to hash from sec_form_body: lots o stuff
    form_body_object = SecFormBody.new(entity_hash[:xml_form_body_link])
    form_body_object.extract_data_from_form_body
    entity_hash[:cik_from_body] = form_body_object.cik
    entity_hash[:entity_name] = form_body_object.entity_name
    entity_hash[:issuer_street1] = form_body_object.issuer_street1
    entity_hash[:issuer_street2] = form_body_object.issuer_street2
    entity_hash[:city] = form_body_object.city
    entity_hash[:state_or_country] = form_body_object.state_or_country
    entity_hash[:state_or_country_description] = form_body_object.state_or_country_description
    entity_hash[:jurisdiction_of_incorporation] = form_body_object.jurisdiction_of_incorporation
    entity_hash[:issuer_previous_name] = form_body_object.issuer_previous_name
    entity_hash[:edgar_Previous_Name_List] = form_body_object.edgar_Previous_Name_List
    entity_hash[:year_of_incorporation] = form_body_object.year_of_incorporation
    entity_hash[:industry] = form_body_object.industry_group
    entity_hash[:type_of_filing] = form_body_object.type_of_filing
    entity_hash[:date_of_first_sale] = form_body_object.date_of_first_sale
    entity_hash[:equity] = form_body_object.equity
    entity_hash[:option_to_acquire] = form_body_object.option_to_acquire
    entity_hash[:business_combination] = form_body_object.business_combination
    entity_hash[:amount_raised] = form_body_object.company_raised_amount
    entity_hash[:amount_offered] = form_body_object.company_offering_amount
    entity_hash[:signature_date] = form_body_object.signature_date

    # add to the final array all the data from each hash for each form
    entities_array << entity_hash
  end

end

output_file = File.open('results', 'w')

  output_file.puts %w(guid cik cik_from_form legal_name form_count state_location, state_domicile 
  form_title link_to_form_page filing_date link_to_html_form  address_first address_second city 
  state state_or_country_description state_incorporation previous_name previous_name2 over_five_years? 
  industry amendment? date_of_first_sale equity? option_to_acquire business_combination amount_raised 
  amount_offered signature_date).join("\t")

entities_array.each do |each_row|
  row = []
  row = [each_row[:guid], each_row[:cik], each_row[:cik_from_body], each_row[:legal_name], 
  each_row[:form_count], each_row[:state_location], each_row[:state_incorporation], each_row[:form_title], 
  each_row[:link_to_form_homepage], each_row[:filed_date], each_row[:html_form_body_link], 
  each_row[:issuer_street1], each_row[:issuer_street2], each_row[:city], each_row[:state_or_country],
  each_row[:state_or_country_description], each_row[:state_incorporation], 
  each_row[:issuer_previous_name], each_row[:edgar_Previous_Name_List], each_row[:over_five_years], 
  each_row[:industry], each_row[:amendment], each_row[:date_of_first_sale], each_row[:equity], 
  each_row[:option_to_acquire], each_row[:business_combination], each_row[:amount_raised], 
  each_row[:amount_offered], each_row[:signature_date]] 
  output_file.puts row.join("\t")
end

output_file.close