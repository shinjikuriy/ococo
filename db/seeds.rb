require 'factory_bot_rails'
require 'faker'

usernames = %w[demo_user01 demo_user02 demo_user03 demo_user04 demo_user05]

# Create demo users with edited profiles
usernames.each do |username|
  next if User.find_by(username: username)
  user = User.create!(FactoryBot.attributes_for(:user_lorem, username: username))
  user.confirm
  user.profile.update(FactoryBot.attributes_for(:profile_lorem))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_urban_hipster))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_nostalgic))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_artisan))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_mystical))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_galactic))

  user.pickles.each do |pickle|
    15.times do
      pickle.journals.create!(FactoryBot.attributes_for(:journal_lorem))
    end
  end
end

# Edit creation time
time = Time.zone.now
user_ids = User.where(username: usernames).pluck(:id)
pickle_ids = Pickle.where(user_id: user_ids).pluck(:id).shuffle
journal_ids = Journal.where(pickle_id: pickle_ids).pluck(:id).shuffle

pickle_ids.each do |id|
  time = time - 3.hours
  Pickle.update!(id, created_at: time)
end

time = Time.zone.now
journal_ids.each do |id|
  time = time - 1.hour
  Journal.update!(id, created_at: time)
end



