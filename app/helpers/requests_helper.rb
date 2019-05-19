module RequestsHelper
	def array_to_hash(participants_array)
        participants_array.size.times.map(&:to_s).zip(participants_array).to_h
    end
end
