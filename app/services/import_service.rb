require 'csv'
require 'pp'
require 'json'

class ImportService
  attr_accessor :district_names, :sgAreas
  def self.import(filename)

    # check for existing data. If exists, wipe.
    if (Place.count != 0)
      start = Time.now
      puts "Flushing data.."
      Place.destroy_all
      finish = Time.now
      flushTime = (finish-start).ceil
      puts "Flushing finished in #{flushTime} seconds"
    end

    start = Time.now
    puts "initializing restaurants..."

    file = File.join Rails.root, filename

    placesCounter = 0
    CSV.foreach(file, headers: true) do |row|

      #places

        postalcode = row['address'][-6..-1]

        place = Place.create(
          name: row['name'],
          address: row['address'],
          place_type: "restaurants",
          coordinates: row['coordinates'][1..-1],
          postalcode: postalcode,
          rating: row['rating'],
          rating_number: row['rating_n'],
        )

        puts "#{place.name} - #{place.errors.full_messages}" if place.errors.any?

        placesCounter += 1 if place.persisted?

      #crowd_level

        #ALL Data
        dataString = row['populartimes']

        crowd_level_data = JSON.parse dataString.gsub(/\s+/, "").gsub("'",'"')

        crowd_level_data.each do |dataset|
          
          day = dataset["name"]

          dataset["data"].each_with_index do |density, hour|

            crowd_level = CrowdLevel.create(

              hour: hour,
              day: day,
              density: density,
              place_id: place.id
            )

          end

        end

    end #of CSV import loop

    finish = Time.now

    timeElapsed = time_ago_in_words((finish-start).ceil)
    puts "Imported #{placesCounter} places."
    puts "Operation finished in #{timeElapsed} seconds}"

  end

  def initDistrict

    district_names = {
      "1": "Raffles Place, Cecil, Marina, People’s Park",
      "2": "Anson, Tanjong Pagar",
      "3": "Queenstown, Tiong Bahru",
      "4": "Telok Blangah, Harbourfront",
      "5": "Pasir Panjang, Hong Leong Garden, Clementi New Town",
      "6": "High Street, Beach Road (part)",
      "7": "Middle Road, Golden Mile",
      "8": "Little India",
      "9": "Orchard, Cairnhill, River Valley",
      "10": "Ardmore, Bukit Timah, Holland Road, Tanglin",
      "11": "Watten Estate, Novena, Thomson",
      "12": "Balestier, Toa Payoh, Serangoon",
      "13": "Macpherson, Braddell",     
      "14": "Geylang, Eunos",
      "15": "Katong, Joo Chiat, Amber Road",
      "16": "Bedok, Upper East Coast, Eastwood, Kew Drive",
      "17": "Loyang, Changi",
      "18": "Tampines, Pasir Ris",
      "19": "Serangoon Garden, Hougang, Ponggol",
      "20": "Bishan, Ang Mo Kio",
      "21": "Upper Bukit Timah, Clementi Park, Ulu Pandan",
      "22": "Jurong",
      "23": "Hillview, Dairy Farm, Bukit Panjang, Choa Chu Kang",
      "24": "Lim Chu Kang, Tengah",
      "25": "Kranji, Woodgrove",
      "26": "Upper Thomson, Springleaf",
      "27": "Yishun, Sembawang",
      "28": "Seletar"
    }

    # district_codes = {
    #   1: [01,02,03,04,05,06],
    #   2: [07,08]
    #   6: [17],
    # }

    # allPlace = Place.all

    # allPlace.each do |place|

    #   # two_digit = place.postalcode < first 2 digits

    #   dCode = district_codes[two_digit]
    #   place.district = dCode

    # end

    # TODO
    # puts "Initiating Districts..."
    # ref : "https://www.mingproperty.sg/singapore-district-code/"
    # Init sg District Hash
    # Loop through each Place object, get first 2 digit of postal code
    # compare with sgDistrict Hash and assign district depending on the 2 digits
    # place district should be integer
  end

  def initArea

    sgAreas = {

      "south" => [1, 2, 3, 4, 5, 6, 7],
      "central" => [8, 9, 10, 11, 12, 20, 21],
      "east" => [13, 14, 15, 16, 17, 18, 19],
      "north" => [25, 26, 27, 28],
      "west" => [22, 23, 24]
    }

    # allPlaces = Place.all

    # allPlaces.each do |place|

    #   place.area = sgAreas.key(place.district)

    # end

    # TODO
    # puts "Initiating Areas..."
    # sgAreas hash should contain area "string" > include which districts
    # based on each place's district, assign area.
  end

end
