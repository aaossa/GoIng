class Preference < ApplicationRecord
	belongs_to :time_block
	has_and_belongs_to_many :requests

	validates :date, presence: true
	validates :date, uniqueness: { scope: :time_block_id }
	validate :date_block_match
	default_scope { order(date: :asc) }
	# Preference.includes(:time_block).order(date: :asc, start: :asc)

	def display_preference
		d = date.strftime("%d/%m/%y")
		"#{d} #{time_block.display_block}"
	end

	def candidates(course)
		course.teaching_assistants.joins(:time_blocks).where(time_blocks: {id: time_block.id})
	end

	private

		def date_block_match
			if time_block.day != date.wday
				errors.add(:date, "mismatch time block selection")
		    end
		end
end
