class Category < ApplicationRecord
  # Canonical category slugs. Kept in sync with config/locales/*.yml (categories.*)
  # and used for seeding and voice-expense parsing.
  SLUGS = %w[
    food
    transportation
    health_and_fitness
    clothes_and_beauty
    rent_and_other_utilities
    insurance
    education
    appliances
    tax
    entertainment
    misc
  ].freeze

  FALLBACK_SLUG = "misc".freeze

  validates_presence_of :slug
end
