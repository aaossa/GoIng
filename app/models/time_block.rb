class TimeBlock < ApplicationRecord
    has_and_belongs_to_many :teaching_assistants
    has_many :preferences
    validates :day, presence: true, inclusion: {in: 1..5}
    validate :start_before_finish

    validates_uniqueness_of :start, scope: :day
    validates_uniqueness_of :finish, scope: :day

    default_scope { order(day: :asc, start: :asc) }


    def self.split_by_weekday(time_blocks, today=DateTime.now.in_time_zone)
        case today.strftime("%u").to_i
        when 6, 7
            [[], time_blocks]
        when 1
            [time_blocks, []]
        else
            today_as_i = today.strftime("%w").to_i
            cut_here = time_blocks.index{ |tb| tb.day >= today_as_i }
            case cut_here
            when 0
                [time_blocks, []]
            when time_blocks.length
                [[], time_blocks]
            else
                [
                    time_blocks.slice(cut_here..time_blocks.length),
                    time_blocks.slice(0..(cut_here - 1))
                ]
            end
        end
    end

    def self.generate_events(on_week, add_week, today=DateTime.now.in_time_zone)
        # Between 7 and 21 days (2 and 3 weeks from now)
        events = []
        # Monday is 1, we need to start from 0
        now = today.beginning_of_week - 1.day
        [1, 2].each do |w|
            on_week.each do |tb|
                events << {
                    internal_id: tb.id,
                    start: now.change({hour: tb.start.hour, min: tb.start.min}) + tb.day.days + w.weeks,
                    finish: now.change({hour: tb.finish.hour, min: tb.finish.min}) + tb.day.days + w.weeks,
                }
            end
            add_week.each do |tb|
                events << {
                    internal_id: tb.id,
                    start: now.change({hour: tb.start.hour, min: tb.start.min}) + tb.day.days + (w + 1).weeks,
                    finish: now.change({hour: tb.finish.hour, min: tb.finish.min}) + tb.day.days + (w + 1).weeks,
                }
            end
        end
        events
    end

    def available_courses
        courses_ids = teaching_assistants.joins(:courses).pluck(:course_id)
        Course.where(id: courses_ids)
    end

    def display_day
        I18n.t('date.day_names')[self[:day]]
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

    private
        def start_before_finish
            errors.add(:finish, "antes de inicio") if start && finish && start >= finish
        end

end
