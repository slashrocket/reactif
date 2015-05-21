# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  domain     :string
#  webhook    :string
#

FactoryGirl.define do
  factory :team do
    association :user
    name Faker::Company.name
    domain Faker::Internet.domain_word
    webhook Faker::Internet.url('hooks.slack.com','/services/T0383B6CH/B04RRMZ1E/')
  end
end
