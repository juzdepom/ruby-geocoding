require 'csv'
require 'json'
require 'http'

Dir['csv/walmart.csv'].each do |file|
  output = []
  i = 0
  CSV.foreach(file) do |row|
    i = i + 1
    puts i
    # puts row.inspect
    storeName, address, city, state, zip = row
    next if address.strip == "#N/A"
    res = HTTP.get("http://geocoder.maplarge.com/geocoder/json", params:{address: address.strip, city: city, state: state, zip: zip, key: "YOUR_API_KEY"})
    data = JSON::parse(res.body)
    # puts data.inspect
    if data["lat"] and data["lng"]
      lat = data["lat"]
      lng = data["lng"]
    else
      puts "ERROR: Could not geocode: " + address
    end
    output << [storeName,address,city,state,zip,lat,lng]

  end
  CSV.open(file.sub(".csv", "-process.csv"), "wb") do |csv|
    output.each do |row|
      csv << row
    end
  end
end
