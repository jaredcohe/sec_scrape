require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

require '../lib/pull_from_database'
require '../lib/sec_form_body'
require '../lib/sec_company_rss_homepage'


cik = "0001439404"
f = SecCompanyRssHomepage.new(cik)
f.get_data_from_rss(2)
pp f.form_count
pp f.title_of_form
pp f.link_to_form_homepage
pp f.filed_label_and_date_filed
pp f.filed_date



=begin

cik_for_rss = cik.to_s.gsub(/^0+/,'')
link_to_rss = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{cik_for_rss}&type=&dateb=&owner=exclude&start=0&count=40&output=atom"
xml_page = Nokogiri::XML(open(link_to_rss)).remove_namespaces!
puts xml_page

=end