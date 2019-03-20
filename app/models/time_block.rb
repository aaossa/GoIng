class TimeBlock < ApplicationRecord
	# validates :name, presence: true, length: { minimum: 5 }

	validates :day, presence: true, inclusion: {in: 1..5}
	validate :start_before_finish

	# validates_uniqueness_of :start, scope: [:teaching_assistant_id, :day]
	# validates_uniqueness_of :finish, scope: [:teaching_assistant_id, :day]

    protected
    	def start_before_finish
    		errors.add(:finish, I18n.t('errors.start_before_finish')) if start && finish && start >= finish
    	end
end
