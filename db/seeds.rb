# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


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
10.times do
	teaching_assistants << TeachingAssistant.new(
		name: Faker::Name.name,
		email: Faker::Internet.email,
		phone_number: Faker::Base.numerify('########'),
	)
end
TeachingAssistant.transaction do
	teaching_assistants.each(&:save!)
end
puts "Created teaching assistants"

# Teaching assistants + courses
Course.all.each do |course|
	course.teaching_assistants << teaching_assistants.sample(rand(1..10))
	course.save
end
puts "Randomly associated course with teaching assistants"