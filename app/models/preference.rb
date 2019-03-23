class Preference < ApplicationRecord
	belongs_to :time_block
	belongs_to :request

	validates :priority, presence: true, inclusion: 1..3
	validates :date, presence: true
	validates :request_id, uniqueness: { scope: :priority }
	validates :request_id, uniqueness: { scope: [:date, :time_block_id] }
	validate :date_block_match
	default_scope { order(priority: :asc) }

	def date_block_match
		if time_block.day != date.wday
			errors.add(:date, "mismatch time block selection")
	    end
	end

	def display_preference
		d = date.strftime("%D")
		"#{d} #{time_block.display_block}"
	end

	def candidates(course)
		course.teaching_assistants.joins(:time_blocks).where(time_blocks: {id: time_block.id})
	end
end
