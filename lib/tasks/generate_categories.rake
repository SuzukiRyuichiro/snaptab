namespace :generate_categories do
  desc "Create categories"
  task all: :environment do
    Category.find_or_create_by!(display_name: 'Food', slug: :food)
    Category.find_or_create_by!(display_name: 'Transportation', slug: :transportation)
    Category.find_or_create_by!(display_name: 'Health & Fitness', slug: :health_and_fitness)
    Category.find_or_create_by!(display_name: 'Clothes & Beauty', slug: :clothes_and_beauty)
    Category.find_or_create_by!(display_name: 'Rent & Other Utilities', slug: :rent_and_other_utilities)
    Category.find_or_create_by!(display_name: 'Insurance', slug: :insurance)
    Category.find_or_create_by!(display_name: 'Education', slug: :education)
    Category.find_or_create_by!(display_name: 'Appliances', slug: :appliances)
    Category.find_or_create_by!(display_name: 'Tax', slug: :tax)
    Category.find_or_create_by!(display_name: 'Entertainment', slug: :entertainment)
    Category.find_or_create_by!(display_name: 'Misc', slug: :misc)

    puts "Now we have #{Category.count} categories"
  end
end
