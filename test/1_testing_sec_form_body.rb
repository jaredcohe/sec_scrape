require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

require '../lib/pull_from_database'
require '../lib/sec_form_body'

=begin

# to do
  # make this work
  # add database pulling
  # make tests

# run program: ruby <name of script> <name of file with guids and CIKs> (could add: > <name of output file>)
# for example: ruby sec_jared.rb test_data_scrape.csv (> results.csv)
# sample RSS link => http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=1439404&type=&dateb=&owner=exclude&start=0&count=40&output=atom
# sample link to list of forms page => http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001439404&owner=exclude&count=40
# sample link to a form page with links to the form => http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/0001439404-10-000003-index.htm
# sample link to the body of a form => http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/primary_doc.xml

# start with a CSV of Guid and CIK
infile = ARGV[0]

# makes an array of arrays, each set of guid and CIK is an element in the array
entities = []
CSV.foreach(infile) {|r| entities << r }

=end

=begin
link_to_rss = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=1439404&type=&dateb=&owner=exclude&start=0&count=40&output=atom"
xml_page = Nokogiri::XML(open(link_to_rss))
xml_page.remove_namespaces!
puts xml_page


link_to_forms_page = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=1439404&owner=exclude&count=40"
xml_page = Nokogiri::XML(open(link_to_forms_page))
puts xml_page

=end

# run get data from sec_form_body
url = "http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/primary_doc.xml"
f = SecFormBody.new(url)
f.extract_data_from_form_body
puts f.cik
puts f.company_raised_amount


=begin 
  
# runs all the functions to gather the data
final_array_result = get_data_for_organization(entities)

f = File.open('results3', 'w')
  f.puts %w(guid cik state_location, state_domicile form_title link_to_form_page filing_date link_to_html_form cik
  legal_name address_first address_second city state state_or_country_description state_incorporation previous_name
  previous_name2 over_five_years? industry amendment? date_of_first_sale equity? option_to_acquire business_combination
  amount_raised amount_offered signature_date).join("\t")

  final_array_result.each do |each_row|
      f.puts each_row.join("\t")
  end
f.close

=end