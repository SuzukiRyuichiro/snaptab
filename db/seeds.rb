Expense.destroy_all
User.destroy_all


user = User.create!(email_address: 'mail@mail.com', password: '123123')

# Create categories for the user
puts 'Creating categories...'
categories_data = [
  'Food', 'Transport', 'Utilities', 'Rent', 'Entertainment',
  'Shopping', 'Health', 'Education', 'Miscellaneous'
]

categories = categories_data.map do |name|
  Category.find_or_create_by!(name: name)
  # You might want to remove this puts if it's too verbose for a production seed file
  # puts "- Category '#{name}' created or found."
end

puts "Categories created/found: #{categories.count}"

# Create about 40 dummy expenses
puts 'Creating dummy expenses...'
descriptions = [
  'Lunch', 'Dinner', 'Coffee', 'Groceries', 'Train ticket', 'Bus fare',
  'Taxi', 'Electricity bill', 'H2O Bill', 'Internet Bill', 'Rent Payment',
  'Movie Ticket', 'Concert', 'Books', 'Clothing', 'Electronics',
  'Doctor Visit', 'Medicine', 'School Supplies', 'Tuition Fee',
  'Gift', 'Subscription', 'Haircut', 'Online Purchase', 'Snacks',
  'Gasoline', 'Car Maintenance', 'Home Repair', 'Pet Supplies', 'Donation',
  'Gym Membership', 'Software License', 'Travel Expenses', 'Restaurant Meal',
  'Bar Tab', 'Hobby Supplies', 'Magazine Subscription', 'Mobile Phone Bill'
]

40.times do
  category = categories.sample
  amount = rand(100..100000) # Random amount in Yen (e.g., ¥100 to ¥100,000)
  description = descriptions.sample
  date = Date.today - rand(1..90).days # Random date within the last 90 days

  user.expenses.create!(
    category: category,
    amount: amount,
    spent_at: date,
    description: description
  )
end
puts "Created #{user.expenses.count} expenses for #{user.email_address}!"
