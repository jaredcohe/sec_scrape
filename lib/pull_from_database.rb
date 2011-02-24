require 'rubygems'
require 'mysql2'

MYSQL_CLIENT = Mysql2::Client.new(:host => "name.vpn", :username => "username", 
:password => "password", :port => 3307, :database => "database_name")

def count_metric(query)
  row = MYSQL_CLIENT.query(query).each {|row| row}
  array_result = row[0]
  hash_result = array_result["count"].to_int rescue 0
end
