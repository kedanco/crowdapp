require 'csv'
require 'pp'
require 'json'

namespace :import do

  desc "import place details from csv & init models with data"

  task :init_restaurants => :environment do

    puts "initializing restaurants..."

    filename = File.join Rails.root, "popularTimes.csv"

    placesCounter = 0
    CSV.foreach(filename, headers: true) do |row|

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
              place: place
            )

          end

        end

    end #of CSV import loop

    puts "Imported #{placesCounter} places."

  end

end
