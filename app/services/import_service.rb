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
  @district_coordinates = []

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

    @district_coordinates = [
      [1.281359, 103.857308],
      [1.272229, 103.842776],
      [1.286210, 103.817980],
      [1.272006, 103.816444],
      [1.295983, 103.777785],
      [1.292532, 103.849176],
      [1.300593, 103.858369],
      [1.310929, 103.854315],
      [1.302403, 103.839263],
      # 10
      [1.313213, 103.806963],
      [1.334023, 103.819581],
      [1.327019, 103.857365],
      [1.334272, 103.874158],
      [1.324489, 103.899800],
      [1.303139, 103.899272],
      [1.326052, 103.946854],
      [1.349646, 103.998077],
      [1.364682, 103.942726],
      [1.376565, 103.896706],
      # 20
      [1.364162, 103.835260],
      [1.346052, 103.781466],
      [1.334059, 103.694739],
      [1.373982, 103.759330],
      [1.403245, 103.702415],
      [1.421948, 103.769030],
      [1.396523, 103.818713],
      [1.435432, 103.837359],
      # 28
      [1.407041, 103.868483]
    ]

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
        lat: @district_coordinates[index].first,
        lng: @district_coordinates[index].last,
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

        puts "dist_id is #{dist_id}"
        place = Place.create!(
          name: row['name'],
          address: row['address'],
          place_type: "restaurant",
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
      # loop through each district, get places in district, Get average of all places in district, assign to district

     # For Areas
      # loop through each area, get districts in area, get average of all districts in area, assign to area

  end


end
