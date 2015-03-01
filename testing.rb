# John Sampson, Michael Weber
# Made at Hack Illinois 2015

# This is just a simple file to test different API calls, seen below. 
# It's also a simpler use case of how the API kind of works. 

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

machineID = "187935" # the machine you want, just for easier access
distance = @access_token.get("/machines/#{machineID}/distanceTraveled",{'startDate' => '2015-02-03T9:00:00.000Z', 'accept'=> 'application/vnd.deere.axiom.v3+json'})

puts distance.body

#parsed_distance = JSON.parse(distance.body.to_s)
#print "Distance Traveled: "
#puts parsed_distance["totalDistance"]
  