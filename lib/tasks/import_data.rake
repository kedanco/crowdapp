require 'csv'
require 'pp'
require 'json'

namespace :import do

  desc "import branch details from csv & init models with data"

  task :init_restaurants => :environment do

    puts "initializing restaurants..."

    restaurants = BusinessCategory.new(name: "restaurants")
    if restaurants.save
      puts "Business Category: #{restaurants.name} added"
    else
      puts restaurants.errors.full_messages
    end

    filename = File.join Rails.root, "popularTimes.csv"

    counter = {:business => 0,:branch => 0,}
    CSV.foreach(filename, headers: true) do |row|

      #business

        # Check if business exist. If so, add to existing business.
        if existingBusiness(row['name'])
          existingName = existingBusiness(row['name'])
          business = Business.create(name: existingName,business_category: restaurants)
        else
          business = Business.create(name: row['name'],business_category: restaurants)
        end

        puts "#{business.name} - #{business.errors.full_messages}" if business.errors.any?

        counter[:business] += 1 if business.persisted?

      #branch

        postalcode = row['address'][-6..-1]

        branch = Branch.create(
          name: row['name'],
          address: row['address'],
          coordinates: row['coordinates'][1..-1],
          postalcode: postalcode,
          rating: row['rating'],
          rating_number: row['rating_n'],
          business: business
        )

        puts "#{branch.name} - #{branch.errors.full_messages}" if branch.errors.any?

        counter[:branch] += 1 if branch.persisted?

      #crowd_level

        #ALL Data
        dataString = row['populartimes']
        # dataString[0] = "{"
        # dataString[-1] = "}"

        crowd_level_data = JSON.parse dataString.gsub(/\s+/, "").gsub("'",'"')

        crowd_level_data.each do |dataset|
          
          day = dataset["name"]

          dataset["data"].each_with_index do |density, hour|

            crowd_level = CrowdLevel.create(

              hour: hour,
              day: day,
              density: density,
              branch: branch
            )

          end

        end

    end #of CSV import loop

    puts "Imported #{counter[:business]} restaurants, with #{counter[:branch]} branches."

  end

  def existingBusiness(name)

    allNames = ((Business.select(:name)).map(&:name)).map(&:downcase)

    # check detail - if existing name contains substring
    bsName = allNames.detect {|existingName| existingName.include?(name.downcase)}

    # check exact, exact match overwrites above // include? is case sensitive
    bsName = allNames.find{name.downcase}

    bsName

  end

end
