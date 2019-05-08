class Course < ApplicationRecord
	has_many :requests
  	has_and_belongs_to_many :teaching_assistants

	validates :name, presence: true, length: { minimum: 5 }

	def available_modules
		time_blocks_ids = teaching_assistants.joins(:time_blocks).pluck(:time_block_id)
		TimeBlock.where(id: time_blocks_ids)
	end

	def available_dates
		possible_days = available_modules.pluck(:day).uniq
		# Check semester range first
		start = Date.today + 1.week
		finish = Date.today + 4.weeks
		(start..finish).select {|date| possible_days.include? date.wday }.map {|date|
			[I18n.l(date, format: '%A %d de %B').humanize, date.to_time.to_i]
		}
	end
end
