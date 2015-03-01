# John Sampson, Michael Weber
# Made at Hack Illinois 2015

require 'oauth'
require 'rubygems'
require 'json'
 
# REPLACE THESE
API_KEY =       "REPLACE ME" # replace these with your keys and stuffs. 
API_SECRET =    "REPLACE ME" # replace these with your keys and stuffs. 
token =         "REPLACE ME" # replace these with your keys and stuffs. 
secret=         "REPLACE ME" # replace these with your keys and stuffs. 

@consumer=OAuth::Consumer.new(API_KEY, API_SECRET, {:site=>"https://api.deere.com/platform"})
 
@access_token = OAuth::AccessToken.new(@consumer, token, secret)
orgMachines = @access_token.get('/organizations/223031/machines',{ 'accept'=> 'application/vnd.deere.axiom.v3+json' })
orgsParsed = JSON.parse(orgMachines.body.to_s)

arrayOfHashes = []

i = 0
while i<orgsParsed["total"] do
  machineID = ((orgsParsed["values"])[i])["id"]
  
  machine = @access_token.get("/machines/#{machineID}",{ 'accept'=> 'application/vnd.deere.axiom.v3+json' })
  parsed_machine = JSON.parse(machine.body.to_s)
  
  deviceStateReports = @access_token.get("/machines/#{machineID}/deviceStateReports",{ 'accept'=> 'application/vnd.deere.axiom.v3+json' })
  parsed_deviceStateReports = JSON.parse(deviceStateReports.body.to_s)
  
  engineHours = @access_token.get("/machines/#{machineID}/engineHours",{ 'accept'=> 'application/vnd.deere.axiom.v3+json' })
  parsed_engineHours = JSON.parse(engineHours.body.to_s)

  if((((parsed_deviceStateReports["values"])[i])["engineState"]) == 0) 
    power = "1"
  else 
    power = "0"
  end
  
  machine = {:name => parsed_machine["name"], :id => machineID.to_i, :power => power, :engineHours => ((parsed_engineHours["reading"])["valueAsDouble"]), :errors => "none"}
  arrayOfHashes.push(machine)
  
  i += 1
end

# add an extra tractor, for demonstrating purposes only
arrayOfHashes.push({:name => "HackIL Demo", :id => machineID.to_i, :power => 1, :engineHours => 36.0, :errors => "RED ECU 000100.01"})

json_final = arrayOfHashes.to_json

puts json_final