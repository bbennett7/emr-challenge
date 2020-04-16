# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Providers
Provider.create(provider_name: "Athena", street_address: "PO Box 12345", city: "Roundtrip Town", state: "RT", zip: "12345", county: "Health County", country: "US", phone_number: "+13105552244", approved: true)
Provider.create(provider_name: "Blue Shield", street_address: "732 Health Ave.", city: "West Hollywood", state: "CA", zip: "12345", county: "Los Angeles County", country: "US", phone_number: "+13105550123", approved: true)
Provider.create(provider_name: "United Health", street_address: "400 Main St.", city: "New York", state: "NY", zip: "11001", county: "New York County", country: "US", phone_number: "+14205553888", approved: true)

# Plans
Plan.create(provider_id: 1, plan_name: "Gold Deductible Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 1, plan_name: "Silver Deductible Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 1, plan_name: "Bronze Deductible Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 2, plan_name: "Global Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 2, plan_name: "Home Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 3, plan_name: "Tier 1 Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 3, plan_name: "Tier 2 Plan", plan_type: nil, approved: true)
Plan.create(provider_id: 3, plan_name: "Tier 3 Plan", plan_type: nil, approved: true)

# Groups
Group.create(provider_id: 1, plan_id: 2, group_number: "847025-123-4567", group_name: "The Core Team")
Group.create(provider_id: 1, plan_id: 2, group_number: "BC-123-4567", group_name: "State Health Plan")

# Policies
Policy.create(group_id: 1, effective_date: "2015-01-01", expiration_date: "2020-12-31", policy_number: "656835555")
Policy.create(group_id: 2, effective_date: nil, expiration_date: nil, policy_number: "000035755")

# Members
Member.create(policy_id: 1, group_id: 1, plan_id: 2, provider_id: 1, member_number: "455444333", first_name: "Jason", last_name: "Smith", ssn_encrypted: "344-99-0000", date_of_birth: "1998-01-01", sex: 0, street_address: nil, city: nil, state: nil, zip: nil, county: nil, country: nil)

# Plan mappers
PlanMapper.create(plan_id: 2, provider_id: 1, source_name: "redox", source_plan_name: "Deductible Plan", source_plan_id: "12345")
PlanMapper.create(plan_id: 2, provider_id: 1, source_name: "providence health", source_plan_name: "High Deductible Plan", source_plan_id: "12345")
PlanMapper.create(plan_id: 2, provider_id: 1, source_name: "abm health", source_plan_name: "Tier 1 Plan", source_plan_id: "372942")

PlanMapper.create(plan_id: 4, provider_id: 2, source_name: "redox", source_plan_name: "XYZ Plan", source_plan_id: "27340-23")
PlanMapper.create(plan_id: 4, provider_id: 2, source_name: "providence health", source_plan_name: "ABC Plan", source_plan_id: "48290370")
PlanMapper.create(plan_id: 4, provider_id: 2, source_name: "abm health", source_plan_name: "JKL Plan", source_plan_id: "2468921")
