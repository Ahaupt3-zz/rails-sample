# Users
User.create!(name:  "Alex Haupt",
             email: "alexhaupt3@gmail.com",
             password:              "Ajames_3",
             password_confirmation: "Ajames_3",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Test User",
             email: "test@test.com",
             password:              "Testing",
             password_confirmation: "Testing",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Microposts
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
