require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

require '../lib/pull_from_database'
require '../lib/sec_form_body'
require '../lib/sec_company_rss_homepage'
require '../lib/sec_company_html_homepage'
require '../lib/sec_form_homepage'

link = 'http://www.sec.gov/Archives/edgar/data/1439404/000143940410000002/0001439404-10-000002-index.htm'
f = SecFormHomepage.new(link)
pp f.xml_form_body_link