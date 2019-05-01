class TimeBlock < ApplicationRecord
  	has_and_belongs_to_many :teaching_assistants
    has_many :preferences
	validates :day, presence: true, inclusion: {in: 1..5}
	validate :start_before_finish

	validates_uniqueness_of :start, scope: :day
	validates_uniqueness_of :finish, scope: :day

    default_scope { order(day: :asc, start: :asc) }

    def available_courses
        courses_ids = teaching_assistants.joins(:courses).pluck(:course_id)
        Course.where(id: courses_ids)
    end

    def available_teaching_assistants
        TeachingAssistant.includes(:time_blocks).where(time_blocks: {id: id})
    end

    def display_day
    	Date::DAYNAMES[self[:day]]
    end

    def display_start
    	self[:start].strftime("%R")
    end

    def display_finish
    	self[:finish].strftime("%R")
    end

    def display_block
    	"#{display_day} (#{display_start}-#{display_finish})"
    end

    protected
    	def start_before_finish
    		errors.add(:finish, I18n.t('errors.start_before_finish')) if start && finish && start >= finish
    	end
end
