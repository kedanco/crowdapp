require 'csv'
require 'pp'
require 'json'
require 'bigdecimal'

class ImportService

  @district_names = []
  @district_codes = []
  @area_districts = {}
  @area_coordinates = {}
  @exceptions = []

  def self.initArea

    puts "Initiating Areas..."

    @area_coordinates = {

      "south" => [1.287985, 103.842042],
      "central" => [1.359377, 103.841870],
      "east" => [1.346604, 103.933046],
      "north" => [1.429982, 103.827502],
      "west" => [1.352529, 103.744663]

    }

    @area_coordinates.each do |key,value|

      newAr = Area.find_or_create_by!(name: key, lat: value[0], lng: value[1])
      puts newAr
      
    end

    puts "#{Area.count} areas created."
    sleep(2)

  end

  def self.initDistrict

    puts "Initiating Districts..."
    # ref : "https://www.mingproperty.sg/singapore-district-code/"

    @district_codes = [
      [1,2,3,4,5,6],
      [7,8],
      [14,15,16],
      [9,10],
      [11,12,13], 
      [17],
      [18,19],
      [20,21],
      [22,23],  
      [24,25,26,27],
      [28,29,30],
      [31,32,33],
      [34,35,36,37],
      [38,39,40,41],
      [42,43,44,45],
      [46,47,48],
      [49,50,81],
      [51,52],
      [53,54,55,82],
      [56,57],
      [58,59],
      [60,61,62,63,64],
      [65,66,67,68],
      [69,70,71],
      [72,73],
      [77,78],
      [75,76],
      [79,80]
    ]

    @area_districts = {

      "south" => [1, 2, 3, 4, 5, 6, 7],
      "central" => [8, 9, 10, 11, 12, 20, 21],
      "east" => [13, 14, 15, 16, 17, 18, 19],
      "north" => [25, 26, 27, 28],
      "west" => [22, 23, 24]

    }

    @district_names = [
      "Raffles Place, Cecil, Marina, People’s Park",
      "Anson, Tanjong Pagar",
      "Queenstown, Tiong Bahru",
      "Telok Blangah, Harbourfront",
      "Pasir Panjang, Hong Leong Garden, Clementi New Town",
      "High Street, Beach Road (part)",
      "Middle Road, Golden Mile",
      "Little India",
      "Orchard, Cairnhill, River Valley",
       "Ardmore, Bukit Timah, Holland Road, Tanglin",
       "Watten Estate, Novena, Thomson",
       "Balestier, Toa Payoh, Serangoon",
       "Macpherson, Braddell",     
       "Geylang, Eunos",
       "Katong, Joo Chiat, Amber Road",
       "Bedok, Upper East Coast, Eastwood, Kew Drive",
       "Loyang, Changi",
       "Tampines, Pasir Ris",
       "Serangoon Garden, Hougang, Ponggol",
       "Bishan, Ang Mo Kio",
       "Upper Bukit Timah, Clementi Park, Ulu Pandan",
       "Jurong",
       "Hillview, Dairy Farm, Bukit Panjang, Choa Chu Kang",
       "Lim Chu Kang, Tengah",
       "Kranji, Woodgrove",
       "Upper Thomson, Springleaf",
       "Yishun, Sembawang",
       "Seletar"
    ]

    # TODO manually initialize district_coordinates

    @district_names.each_with_index do |district,index|

      area_name = (@area_districts.find{|key, value| value.include?(index+1)}).first

      District.find_or_create_by!(
        name: district,
        # lat:
        # lng:
        area_id: Area.find_by(name: area_name).id
      ) 

    end

    puts "#{District.count} districts created."
    sleep(2)

  end

  def self.import(filename)

    # check for existing data. If exists, wipe.
    if (Place.count != 0)
      start = Time.now
      puts "Flushing data.."
      Place.destroy_all
      finish = Time.now
      flushTime = (finish-start).ceil
      puts "Flushing finished in #{flushTime} seconds"
      sleep(2)
    end

    ImportService.initArea()
    ImportService.initDistrict()

    start = Time.now
    puts "initializing restaurants..."

    file = File.join Rails.root, filename

    CSV.foreach(file, headers: true) do |row|

      #places

        postalcode = row['address'][-6..-1]

        if !postalcode.is_number?

           #Searches for postalcode within address string
           result = row['address'].scan(/\b\d{6}\b/)

           if !result.empty?
              postalcode = result[0]
           else

            @exceptions << row['name'] + " " + row['address']
            puts "added #{row['name']} to exception list."
            puts "skipping row..."
            sleep(3)
            next

          end

        end

        coordinates = row['coordinates'].split(",")

        two_digit_postalcode = postalcode[0..1]

        dist_id = @district_codes.index{ |codes| codes.include?(two_digit_postalcode.to_i) } +1

        puts "dist_id is #{dist_id}",
        place = Place.create!(
          name: row['name'],
          address: row['address'],
          place_type: "restaurants",
          lat: BigDecimal((coordinates[0].split(":"))[1]),
          lng: BigDecimal((coordinates[1].split(":"))[1]),
          postalcode: postalcode,
          rating: row['rating'],
          rating_number: row['rating_n'],
          district_id: dist_id
        )

        puts "#{place.name} - #{place.errors.full_messages}" if place.errors.any?

      #crowd_level

        #ALL Data
        dataString = row['populartimes']

        crowd_level_data = JSON.parse dataString.gsub(/\s+/, "").gsub("'",'"')

        crowd_level_data.each do |dataset|
          
          day = dataset["name"]

          # hour refers to start of hour: '0' means midnight-1am
          dataset["data"].each_with_index do |density, hour|

            crowd_level = CrowdLevel.create!(

              hour: hour,
              day: day,
              crowd_density: density,
              place_id: place.id
            )

          end

        end

    end #of CSV import loop

    finish = Time.now

    timeElapsed = (finish-start).ceil
    puts "Imported #{Place.count} places."
    puts "Operation finished in #{timeElapsed} seconds"

    if !@exceptions.empty?

      puts "=============================================="
      puts "Exception List: #{@exceptions.count} exceptions."
      pp @exceptions

    end

  end

  def initCrowdDensity #TODO 

    # For Districts
      # Get average of all places in district

     # For Areas
      # get average of all districts in area

  end


end
