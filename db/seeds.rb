# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_uc_email
	uc_domain = ['uc.cl', 'correo.puc.cl', 'puc.cl'].sample
	"#{Faker::Internet.user_name}@#{uc_domain}"
end

N_TAs = 20
N_Users = 40
N_Requests = 50

# Courses
courses = Course.create([
	{ name: 'Cálculo 1' },
	{ name: 'Cálculo 2' },
	{ name: 'Cálculo 3' },
	{ name: 'Álgebra Lineal' },
	{ name: 'Introducción a la Programación' },
	{ name: 'Química para Ingenieros' },
	{ name: 'Dinámica' },
])
puts "Created courses"

# Teaching assistants
teaching_assistants = []
N_TAs.times do
	teaching_assistants << TeachingAssistant.new(
		name: Faker::Name.name,
		email: random_uc_email,
		phone_number: Faker::Base.numerify('########'),
	)
end
TeachingAssistant.transaction do
	teaching_assistants.each(&:save!)
end
puts "Created teaching assistants"

# Teaching assistants + courses
Course.all.each do |course|
	course.teaching_assistants << TeachingAssistant.all.sample(rand(1..N_TAs))
	course.save
end
puts "Randomly associated courses with teaching assistants"

# Time blocks
now = DateTime.now.in_time_zone.beginning_of_week.change({sec: 0})
Date::DAYNAMES[1..6].each_with_index.each do |name, index|
	TimeBlock.create([
		{ day: index, start: now.change({hour: 8, min: 30}), finish: now.change({hour: 9, min: 50}) },
		{ day: index, start: now.change({hour: 10, min: 00}), finish: now.change({hour: 11, min: 20}) },
		{ day: index, start: now.change({hour: 11, min: 30}), finish: now.change({hour: 12, min: 50}) },
		{ day: index, start: now.change({hour: 13, min: 00}), finish: now.change({hour: 14, min: 00}) },
		{ day: index, start: now.change({hour: 14, min: 00}), finish: now.change({hour: 15, min: 20}) },
		{ day: index, start: now.change({hour: 15, min: 30}), finish: now.change({hour: 16, min: 50}) },
		{ day: index, start: now.change({hour: 17, min: 00}), finish: now.change({hour: 18, min: 20}) },
	])
end
puts "Created time blocks"

# Teaching assistants + time blocks
N_TBs = TimeBlock.count
TeachingAssistant.all.each do |teaching_assistant|
	teaching_assistant.time_blocks << TimeBlock.all.sample(rand(2..4))
	teaching_assistant.save
end
puts "Randomly associated time blocks with teaching assistants"

# Users
users = []
N_Users.times do
	users << User.new(
		google_name: Faker::Name.name,
		google_email: random_uc_email,
		google_image: Faker::LoremPixel.image,
		google_token: Faker::Quote.singular_siegler,
	)
end
User.transaction do
	users.each(&:save!)
end
puts "Created users"

# Requests
requests = []
now = now + 1.week
N_Requests.times do
	course = Course.all.sample
	participants = {}
	rand(0..3).times do |key|
		participants[key.to_s] = random_uc_email
	end
	new_request = Request.new(
		participants: participants,
		contents: Faker::Lorem.characters(rand(5..10)),
		user: users.sample,
		course: course,
	)
	rand(1..3).times do |index|
		time_block = course.available_modules.sample
		new_request.preferences << Preference.where(
			date: now + (time_block.day - 1).days + index.weeks,
			time_block: time_block,
		).first_or_create
	end
	requests << new_request
end
Request.transaction do
	requests.each(&:save!)
end
puts "Created requests"
