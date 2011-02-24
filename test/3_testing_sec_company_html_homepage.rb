require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

require '../lib/pull_from_database'
require '../lib/sec_form_body'
require '../lib/sec_company_rss_homepage'
require '../lib/sec_company_html_homepage'

cik = '0001439404'
f = SecCompanyHtmlHomepage.new(cik)
xml_page_for_company_html = f.xml_page
f.get_data_from_company_html_page(xml_page_for_company_html)
pp f.state_location
pp f.state_incorporation
pp f.legal_name