class Course < ApplicationRecord
	has_many :requests
  	has_and_belongs_to_many :teaching_assistants
	validates :name, presence: true, length: { minimum: 5 }

	def available_modules
		time_blocks_ids = teaching_assistants.joins(:time_blocks).pluck(:time_block_id)
		TimeBlock.where(id: time_blocks_ids)
	end
end
