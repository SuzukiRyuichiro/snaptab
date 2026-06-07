namespace :generate_categories do
  desc "Create categories"
  task all: :environment do
    Category.find_or_create_by!(slug: :food)
    Category.find_or_create_by!(slug: :transportation)
    Category.find_or_create_by!(slug: :health_and_fitness)
    Category.find_or_create_by!(slug: :clothes_and_beauty)
    Category.find_or_create_by!(slug: :rent_and_other_utilities)
    Category.find_or_create_by!(slug: :insurance)
    Category.find_or_create_by!(slug: :education)
    Category.find_or_create_by!(slug: :appliances)
    Category.find_or_create_by!(slug: :tax)
    Category.find_or_create_by!(slug: :entertainment)
    Category.find_or_create_by!(slug: :misc)

    puts "Now we have #{Category.count} categories"
  end
end
