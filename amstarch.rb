require 'httparty'
require 'pp'
require 'active_support/core_ext/enumerable'
require 'fileutils'
require 'yaml'

#CONFIG DETAILS
config = YAML.load(File.read("config.cfg"))
inventory_number = config["inventory_number"].to_i
archive_ref = config["archive_ref"].to_i
archive_abriviation = config["archive_abriviation"].to_s

#setup url
urlbase = "https://webservices.picturae.com/archives/scans/"
key = "?apiKey=eb37e65a-eb47-11e9-b95c-60f81db16c0e"

#use httparty to get the basic info from the City Archives Site
response = HTTParty.get(urlbase + inventory_number.to_s + "/" + archive_ref.to_s + key)
p "Inventory Found"
#parse the response from the City Archives Site
parsed = response.parsed_response

#calculate how many pages will need to be iterated over (hard limit of 50 results per query)
pages = (parsed['scans']['scancount'] /50.0).ceil

#set new empty imageurls array
imageurls = []

#set i to 1 for following loop
i = 1
#start loop to iterate through pages to get the urls for the scans
while i <= pages
    #set start at number
    startat = (50*i)-50
    #httparty gets the list of scans 
    response = HTTParty.get(urlbase + inventory_number.to_s + "/" + archive_ref.to_s + key + "&limit=50&start=" + startat.to_s)
    #display what pages it is on
    p "Getting page " + i.to_s + " of " + pages.to_s
    
    #for each scan: get the image id, build the fullsize image url, and send url to imageurl array
    response.parsed_response['scans']['scans'].each do |links|
        imageurls << "https://download-images.memorix.nl/ams/download/fullsize/" + links['id'] + ".jpg"
    end    
    i += 1 
end

#set loop to interate over each of the imageurls and save the image to a new folder
directory = inventory_number.to_s + archive_abriviation + archive_ref.to_s.split(".").join("-").to_s + "/"
FileUtils.mkdir_p directory
errored = []

n = 1
imageurls.each do |save|
    name = inventory_number.to_s + archive_abriviation + archive_ref.to_s.split(".").join("-").to_s + "/" + "CAA" + inventory_number.to_s + archive_abriviation + archive_ref.to_s.split(".").join("-").to_s + "p" + n.to_s + ".jpg"
    if File.file?(name) == false
        open(name, 'wb' ) do |file|
            p "Downloading image " + n.to_s + " of " + imageurls.count.to_s
            begin
                file << HTTParty.get(save)
            #if an error occurs with the connection, it will add it to the error array
            rescue HTTParty::Error
                errored << [save,n]
            end
        end
    end
    n += 1
end

#try to fix the errors twice
v = 1
while (errored.empty? == false) && (v <=2)
    p "error fix try " + v.to_s 
    errored.each do |save|
        name = inventory_number.to_s + archive_abriviation + archive_ref.to_s.split(".").join("-").to_s + "/" + "CAA" + inventory_number.to_s + archive_abriviation + archive_ref.to_s.split(".").join("-").to_s + "p" + save[1].to_s + ".jpg"
        p name
        if File.file?(name) == false
            open(name, 'wb' ) do |file|
                begin
                    file << HTTParty.get(save[0])
                rescue HTTParty::Error
                    errored << save
                end
            end
        end
    end
    v += 1    
end

#if errors still exisit, print out errors
if errored.empty? == false
    p "there were errors with the following files"
    errored.each do |list|
        p list[0]
    end 
end
p "FINISHED: Downloaded images to " + inventory_number.to_s + archive_abriviation + archive_ref.to_s.split(".").join("-").to_s
